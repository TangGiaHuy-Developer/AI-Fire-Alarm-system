from flask import Flask, Response, jsonify, request
from flask_cors import CORS
import cv2, time, threading, logging, requests
from queue import Queue
from collections import deque
from ultralytics import YOLO
import serial

# ================= CONFIG =================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("fire-local")
NHO_DEM = 1

app = Flask(__name__)
CORS(app)

# ⭐ URL Server Cloud (Render)
CLOUD_SERVER_URL = "https://bao-chay-api-tagname.onrender.com"  # ← Thay URL Render của bạn

# ================= LOAD MODEL =================
try:
    model = YOLO("models/weights/best.pt")
    logger.info("✅ YOLO model loaded")
except Exception as e:
    logger.error(f"❌ Model load failed: {e}")
    model = None

# ================= SERIAL (OPTIONAL) =================
ser = None
try:
    ser = serial.Serial(port="COM4", baudrate=9600, timeout=1)
    logger.info("✅ Serial COM4 connected")
except Exception as e:
    logger.warning(f"⚠️ Serial not available: {e}")

# ================= LOCAL EVENT LOGS =================
LOCAL_LOGS = deque(maxlen=50)


def push_to_cloud_server(cam_id, alert_level, boxes):
    """Gửi event detection lên Cloud Server"""
    try:
        payload = {
            "cam_id": cam_id,
            "alert_level": alert_level,
            "boxes": boxes,
            "timestamp": time.strftime("%H:%M:%S")
        }
        
        response = requests.post(
            f"{CLOUD_SERVER_URL}/api/events/push",
            json=payload,
            timeout=5
        )
        
        if response.status_code == 200:
            logger.info(f"✅ Event pushed to cloud: {cam_id} - {alert_level}")
        else:
            logger.warning(f"⚠️ Cloud push failed: {response.status_code}")
            
    except requests.exceptions.RequestException as e:
        logger.error(f"❌ Cannot reach cloud server: {e}")
    except Exception as e:
        logger.error(f"❌ Push error: {e}")


# ================= CAMERA CLASS =================
class CameraStream:
    def __init__(self, cam_id: str, source=0):
        self.cam_id = cam_id
        self.cap = cv2.VideoCapture(source)
        
        if not self.cap.isOpened():
            logger.warning(f"⚠️ Camera {cam_id} cannot be opened")
            self.cap = None

        self.frame_queue = Queue(maxsize=1)
        self.lock = threading.Lock()

        self.status = {
            "alert_level": "disconnected" if self.cap is None else "ok",
            "fps": 0,
            "bboxes": []
        }

        # State management
        self.last_alert = "ok"
        self.prev_alert = "ok"
        self.hold_until = 0
        self.last_push_time = 0  # ⭐ Tránh spam server

        self.running = True
        threading.Thread(target=self.loop, daemon=True).start()
        logger.info(f"📹 Camera {cam_id} initialized")

    def loop(self):
        prev = time.time()

        while self.running:
            if self.cap is None:
                with self.lock:
                    self.status = {
                        "alert_level": "disconnected",
                        "fps": 0,
                        "bboxes": []
                    }
                time.sleep(1)
                continue

            ret, frame = self.cap.read()
            if not ret:
                time.sleep(0.05)
                continue

            annotated = frame.copy()
            alert = "ok"
            boxes = []
            now = time.time()

            # ===== AI DETECTION =====
            if model:
                try:
                    results = model.predict(frame, conf=0.3, imgsz=640, verbose=False)[0]

                    if results.boxes:
                        for b in results.boxes:
                            cls = int(b.cls[0])
                            conf = float(b.conf[0])
                            x1, y1, x2, y2 = map(int, b.xyxy[0])

                            label = "fire" if cls == 0 else "smoke"
                            alert = "critical" if label == "fire" else "warning"
                            color = (0, 0, 255) if alert == "critical" else (0, 215, 255)

                            cv2.rectangle(annotated, (x1, y1), (x2, y2), color, 2)
                            cv2.putText(
                                annotated,
                                f"{label.upper()} {conf:.2f}",
                                (x1, y1 - 6),
                                cv2.FONT_HERSHEY_SIMPLEX,
                                0.5,
                                color,
                                1
                            )

                            boxes.append({
                                "class": label,
                                "confidence": conf,
                                "bbox": [x1, y1, x2, y2]
                            })

                        self.last_alert = alert
                        self.hold_until = now + 0.3
                except Exception as e:
                    logger.error(f"Detection error: {e}")

            # ===== HOLD ALERT =====
            if not boxes and now < self.hold_until:
                alert = self.last_alert

            # ===== PUSH TO CLOUD (khi alert thay đổi) =====
            if alert != self.prev_alert:
                # Push to cloud server
                push_to_cloud_server(self.cam_id, alert, boxes)
                
                # Local log
                LOCAL_LOGS.appendleft({
                    "cam_id": self.cam_id,
                    "alert": alert,
                    "timestamp": time.strftime("%H:%M:%S"),
                    "boxes_count": len(boxes)
                })
                
                # Serial trigger (nếu có)
                if alert == "critical" and ser:
                    try:
                        ser.write(b'1')
                    except Exception as e:
                        logger.error(f"Serial write failed: {e}")

                self.prev_alert = alert
                self.last_push_time = now

            # ⭐ Push định kỳ nếu vẫn đang cháy (mỗi 10s)
            elif alert in ("critical", "warning") and (now - self.last_push_time) > 10:
                push_to_cloud_server(self.cam_id, alert, boxes)
                self.last_push_time = now

            # ===== FPS =====
            fps = int(1 / (now - prev)) if now != prev else 0
            prev = now

            with self.lock:
                self.status = {
                    "alert_level": alert,
                    "fps": fps,
                    "bboxes": boxes
                }

            # Encode frame
            ok, jpg = cv2.imencode(".jpg", annotated, [cv2.IMWRITE_JPEG_QUALITY, 85])
            if ok and not self.frame_queue.full():
                self.frame_queue.put(jpg.tobytes())

    def get_frame(self):
        return self.frame_queue.get() if not self.frame_queue.empty() else None

    def get_status(self):
        with self.lock:
            return self.status


# ================= CAMERA REGISTRY =================
cameras = {}
try:
    cameras["cam1"] = CameraStream("cam1", 0)  # Webcam
except Exception as e:
    logger.error(f"Failed to initialize cam1: {e}")


# ================= ROUTES =================

@app.route("/health")
def health():
    return jsonify({
        "status": "ok",
        "cameras": {k: v.get_status() for k, v in cameras.items()},
        "serial_connected": ser is not None,
        "cloud_server": CLOUD_SERVER_URL
    })


@app.route("/stream/<cam_id>")
def stream(cam_id):
    """Stream video feed"""
    cam = cameras.get(cam_id)
    if not cam:
        return "Camera not found", 404

    def gen():
        last = None
        while True:
            frame = cam.get_frame()
            if frame:
                last = frame
            if last:
                yield (
                    b"--frame\r\n"
                    b"Content-Type: image/jpeg\r\n\r\n" +
                    last + b"\r\n"
                )
            time.sleep(0.03)

    return Response(gen(), mimetype="multipart/x-mixed-replace; boundary=frame")


@app.route("/detection/<cam_id>")
def detection(cam_id):
    """Get detection status"""
    cam = cameras.get(cam_id)
    if not cam:
        return jsonify({
            "alert_level": "disconnected",
            "fps": 0,
            "bboxes": []
        })
    return jsonify(cam.get_status())


@app.route("/api/local-logs")
def get_local_logs():
    """Get local detection logs"""
    return jsonify(list(LOCAL_LOGS))


# ================= MAIN =================
if __name__ == "__main__":
    print("\n" + "="*50)
    print("🔥 LOCAL BACKEND STARTED")
    print("="*50)
    print(f"📹 Camera stream: http://localhost:5000/stream/cam1")
    print(f"📊 Detection API: http://localhost:5000/detection/cam1")
    print(f"☁️  Cloud Server: {CLOUD_SERVER_URL}")
    print("="*50 + "\n")
    
    app.run("0.0.0.0", 5000, threaded=True)