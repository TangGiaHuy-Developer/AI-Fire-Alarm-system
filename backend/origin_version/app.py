from flask import Flask, Response, jsonify, request
from flask_cors import CORS
import cv2, time, threading, logging, uuid , requests
from queue import Queue
from collections import deque
from ultralytics import YOLO
# ================= SERIAL ===================
import serial
# ================= FIREBASE & FCM =================
import firebase_admin
from firebase_admin import credentials, messaging
# ================= CONFIG =================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("fire-backend")
NHO_DEM = 1
app = Flask(__name__)
CORS(app)

CLOUD_SERVER_URL = "https://bao-chay-api-tagname.onrender.com"

# ================= INIT FIREBASE =================
try:
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)
    logger.info("✅ Firebase Admin initialized successfully")
except Exception as e:
    logger.warning(f"⚠️ Could not initialize Firebase: {e}")

# Lưu trữ FCM Token
fcm_tokens = set()


# ================= LOAD MODEL =================
try:
    model = YOLO("models/weights/best.pt")
    logger.info("YOLO model loaded")
except Exception as e:
    logger.error(f"❌ Model load failed: {e}")
    model = None

# ================= SERIAL (OPTIONAL) =================
ser = None
try:
    ser = serial.Serial(
        port="COM4",     # Phụ thuộc vào WINDOWS nhận COM1,COM2,COM3,...
        baudrate=9600,
        timeout=1
    )
    logger.info("Serial COM connected ✅✅✅")
except Exception as e:
    logger.warning(f"Serial not available: {e}")
    ser = None

# ================= EVENT LOGS =================
EVENT_LOGS = deque(maxlen=100)
def send_fcm_alert(cam_id, alert_level):
    if not fcm_tokens:
        return

    if alert_level == "critical" :
        title = "CẢNH BÁO KHẨN CẤP! 🔥"
    body = f"Phát hiện lửa tại {cam_id}. Kiểm tra ngay!"

    # Tạo bản sao danh sách token
    tokens_list = list(fcm_tokens)
    failed_tokens = []

    logger.info(f"🚀 Preparing to send to {len(tokens_list)} devices...")
    for token in tokens_list:
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body,
                ),
                data={
                    "cam_id": cam_id,
                    "type": "FIRE_ALERT",
                    "click_action": "FLUTTER_NOTIFICATION_CLICK"
                },
                token=token 
            )
            
            response = messaging.send(message)
            logger.info(f"✅ Sent to device! ID: {response}")

        except messaging.UnregisteredError:
            logger.warning(f"⚠️ Token invalid/expired, removing...")
            failed_tokens.append(token)
        except Exception as e:
            logger.error(f"❌ Error sending: {e}")

    for t in failed_tokens:
        fcm_tokens.discard(t)

def push_event(cam_id, alert_level, boxes):
    EVENT_LOGS.appendleft({
        "id": str(uuid.uuid4()),
        "type": (
            "CRITICAL" if alert_level == "critical"
            else "WARNING" if alert_level == "warning"
            else "INFO"
        ),
        "message": (
            "Phát hiện LỬA" if alert_level == "critical"
            else "Phát hiện KHÓI" if alert_level == "warning"
            else "Camera hoạt động bình thường"
        ),
        "camera": cam_id,
        "timestamp": time.strftime("%H:%M:%S"),
        "confidence": max([b["confidence"] for b in boxes], default=None),
        "confirmed": None   # None | "true" | "false"
    })

    """Gửi event detection lên Cloud Server"""
def push_to_cloud_server(cam_id, alert_level, boxes):
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
        self.cap = cv2.VideoCapture(source, cv2.CAP_DSHOW)
        self.cap.set(cv2.CAP_PROP_BUFFERSIZE, NHO_DEM)

        if not self.cap.isOpened():
            raise RuntimeError("Cannot open camera")

        self.frame_queue = Queue(maxsize=1)
        self.lock = threading.Lock()

        self.status = {
            "alert_level": "ok",
            "fps": 0,
            "bboxes": []
        }

        # === STATE ===
        self.last_alert = "ok"
        self.prev_alert = "ok"
        self.hold_until = 0
        self.last_push_time = 0

        self.raw_frame = None
        self.running = True
        
        # Thread đọc camera liên tục
        threading.Thread(target=self.capture_thread, daemon=True).start()
        # Thread xử lý AI
        threading.Thread(target=self.loop, daemon=True).start()
        logger.info(f"Camera {cam_id} started with decoupled capture/processing")

    def capture_thread(self):
        """Luồng này chỉ làm nhiệm vụ duy nhất là đọc frame mới nhất từ camera"""
        while self.running:
            if self.cap is not None:
                ret, frame = self.cap.read()
                if ret:
                    self.raw_frame = frame
            time.sleep(0.01) # Tránh chiếm dụng CPU quá mức

    def loop(self):
        prev = time.time()

        while self.running:
            current_raw = self.raw_frame
            if current_raw is None:
                time.sleep(0.01)
                continue

            frame = current_raw.copy()

            annotated = frame.copy()
            alert = "ok"
            boxes = []
            now = time.time()

            # ===== AI DETECTION =====
            if model:
                try:
                    # Giảm imgsz xuống 320 để tăng tốc inference trên CPU
                    r = model.predict(frame, conf=0.3, imgsz=320, verbose=False)[0]

                    if r.boxes:
                        for b in r.boxes:
                            cls = int(b.cls[0])
                            conf = float(b.conf[0])
                            x1, y1, x2, y2 = map(int, b.xyxy[0])

                            label = "fire" if cls == 0 else "smoke"
                            alert = "critical" if label == "fire" else "warning"
                            color = (0, 0, 255) if alert == "critical" else (0, 215, 255)

                            # === DRAW BBOX ===
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

            # ===== HOLD ALERT (ANTI FLICKER) =====
            if not boxes and now < self.hold_until:
                alert = self.last_alert

            # ===== PUSH EVENT WHEN STATE CHANGES =====
            if alert != self.prev_alert:
                 # Push to cloud server
                # push_to_cloud_server(self.cam_id, alert, boxes)
                self.prev_alert = alert
                self.last_push_time = now
                # Push event (nhanh, ko cần thread)
                push_event(self.cam_id, alert, boxes)
                
                # Serial trigger - Chuyển sang thread để không block camera loop
                if alert == "critical" and ser:
                    def send_serial():
                        try:
                            if ser: # Double check for linter safety
                                ser.write(b'1')
                        except Exception as e:
                            logger.error(f"Serial write failed: {e}")
                    threading.Thread(target=send_serial, daemon=True).start()

                threading.Thread(
                    target=push_to_cloud_server,
                    args=(self.cam_id, alert, boxes),
                    daemon=True
                ).start()
                # Tạm để test code
                # self.prev_alert = alert
            # Push định kỳ nếu vẫn đang cháy (mỗi 10s)
            elif alert in ("critical", "warning") and (now - self.last_push_time) > 10:
                self.last_push_time = now
                threading.Thread(
                    target=push_to_cloud_server,
                    args=(self.cam_id, alert, boxes),
                    daemon=True
                ).start()   
                             
            # ===== FPS =====
            fps = int(1 / (now - prev)) if now != prev else 0
            prev = now

            with self.lock:
                self.status = {
                    "alert_level": alert,
                    "fps": fps,
                    "bboxes": boxes
                }

            ok, jpg = cv2.imencode(".jpg", annotated, [cv2.IMWRITE_JPEG_QUALITY, 85])
            if ok and not self.frame_queue.full():
                self.frame_queue.put(jpg.tobytes())

    def get_frame(self):
        return self.frame_queue.get() if not self.frame_queue.empty() else None

    def get_status(self):
        with self.lock:
            return self.status

# ================= CAMERA REGISTRY =================
cameras = {
    "cam1": CameraStream("cam1", 0)  # webcam
}

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
    cam = cameras.get(cam_id)
    if not cam:
        return "Not found", 404

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
    cam = cameras.get(cam_id)
    if not cam:
        return jsonify({
            "alert_level": "disconnected",
            "fps": 0,
            "bboxes": []
        })
    return jsonify(cam.get_status())

@app.route("/api/events/latest")
def get_events():
    return jsonify(list(EVENT_LOGS))

# ===== CONFIRM FALSE (NHẬN NHẦM) =====
@app.route("/api/events/confirm-false", methods=["POST"])
def confirm_false():
    for e in EVENT_LOGS:
        if e["confirmed"] is None:
            e["confirmed"] = "false"
            e["type"] = "INFO"
            e["message"] = "Xác nhận nhận nhầm"
    return jsonify({"ok": True})

# ===== CONFIRM TRUE (CHÁY THẬT) =====
@app.route("/api/events/confirm-true", methods=["POST"])
def confirm_true():
    for e in EVENT_LOGS:
        if e["confirmed"] is None:
            e["confirmed"] = "true"
            e["type"] = "CRITICAL"
            e["message"] = "BÁO CÁO CHÁY THẬT"
    return jsonify({"ok": True})
# ==== REGISTER TOKEN =====
@app.route("/api/register-token", methods=["POST"])
def register_token():
    try:
        data = request.json
        token = data.get("token")
        if token:
            fcm_tokens.add(token)
            logger.info(f"📱 Registered Device Token: {token[:15]}...")
            return jsonify({"status": "success", "message": "Token added"}), 200
        else:
            return jsonify({"status": "error", "message": "Missing token"}), 400
    except Exception as e:
        logger.error(f"Token error: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500
    
@app.route("/api/local-logs")
def get_local_logs():
    """Get local detection logs"""
    return jsonify(list(EVENT_LOGS))

# ================= MAIN =================
if __name__ == "__main__":
    app.run("0.0.0.0", 5000, threaded=True)
