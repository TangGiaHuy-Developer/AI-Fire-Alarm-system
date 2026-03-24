import cv2, time, threading, logging, requests, os, json
from queue import Queue, Empty
from ultralytics import YOLO
import torch
import numpy as np

# ================= CONFIG & OPTIMIZATION =================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("fire-edge-node-turbo")

# Tối ưu hóa OpenCV và Torch cho hiệu suất tuyệt đối
cv2.setNumThreads(0) 
torch.backends.cudnn.benchmark = True

CENTRAL_SERVER_URL = "http://localhost:5000"  
NODE_ID = "cam1" 
NODE_NAME = "Văn Phòng - Camera 1"
CAMERA_SOURCE = 0 # Hoặc Link RTSP

# ================= TỰ ĐỘNG CẤU HÌNH PHẦN CỨNG & MODEL (TĂNG FPS) =================
device = "cuda" if torch.cuda.is_available() else "cpu"
if device == "cuda":
    gpu_name = torch.cuda.get_device_name(0)
    logger.info(f"🚀 PHÁT HIỆN GPU: {gpu_name} - BẤT CHẤP TỐI ƯU!")
else:
    logger.warning("⚠️ CPU Mode - Đang tự động tìm hoặc tạo Model tối ưu 30 FPS...")

try:
    # Tự động nhận diện model đã được tăng tốc (OpenVINO / ONNX)
    base_path = "models/weights/best"
    
    if os.path.exists(base_path + "_openvino_model"):
        model_path = base_path + "_openvino_model"
        logger.info("🚀 TÌM THẤY OPENVINO MODEL - Tốc độ CPU cực hạn!")
        model = YOLO(model_path, task="detect")
    elif os.path.exists(base_path + ".onnx"):
        model_path = base_path + ".onnx"
        logger.info("⚡ TÌM THẤY ONNX MODEL - Nhanh hơn file gốc!")
        model = YOLO(model_path, task="detect")
    else:
        logger.warning("🛠️ Chưa có model tối ưu tốc độ cao. Đang TỰ ĐỘNG XUẤT RA OPENVINO / ONNX...")
        temp_model = YOLO("models/weights/best.pt")
        
        # Thử xuất OpenVINO trước (nhanh nhất cho CPU Intel/AMD)
        try:
            logger.info("⏳ Đang xuất ra OpenVINO (Chỉ làm 1 lần duy nhất, mất khoảng 1 phút)...")
            temp_model.export(format="openvino", int8=True)
            model_path = base_path + "_openvino_model"
            logger.info("🎉 Xuất OpenVINO thành công! Từ giờ sẽ luôn chạy ở 30+ FPS")
        except Exception as e_vino:
            logger.warning(f"⚠️ Không thể xuất OpenVINO: {e_vino}. Chuyển sang thử ONNX...")
            # Nếu trượt OpenVINO thì thử ONNX
            try:
                temp_model.export(format="onnx")
                model_path = base_path + ".onnx"
                logger.info("🎉 Xuất ONNX thành công!")
            except Exception as e_onnx:
                logger.error(f"❌ Cả 2 cách tối ưu đều lỗi. Sẽ dùng mặc định (Chậm). Lỗi: {e_onnx}")
                model_path = base_path + ".pt"
                
        # Nạp lại model siêu tốc vừa export
        model = YOLO(model_path, task="detect")
        
    logger.info("✅ YOLO model sẵn sàng hoạt động ở FPS cao nhất. (Đã vô hiệu hóa .half() để chống GPU/CPU Crash Backend của PyTorch Windows)!")
except Exception as e:
    logger.error(f"❌ Lỗi load model: {e}")
    model = None

# ================= TURBO CAMERA PIPELINE =================
class TurboCameraStream:
    def __init__(self, node_id, source):
        self.node_id = node_id
        
        # 2. TỐI ƯU CAMERA TRÊN WINDOWS ĐỂ ĐẠT 30 FPS THAY VÌ 1 FPS
        if isinstance(source, int) or str(source).isdigit():
            # Dùng DirectShow API trên Windows sẽ triệt tiêu độ trễ đọc Camera
            self.cap = cv2.VideoCapture(int(source), cv2.CAP_DSHOW)
            
            # Ép hệ thống dùng nén MJPG thay vì Raw YUYV siêu tốn băng thông USB
            self.cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*'MJPG'))
            # Thiết lập độ phân giải nén để tăng tốc (Vẫn đủ rõ cho YOLO)
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        else:
            self.cap = cv2.VideoCapture(source)
            
        self.cap.set(cv2.CAP_PROP_BUFFERSIZE, 1) # Bỏ qua frame cũ
        self.cap.set(cv2.CAP_PROP_FPS, 30)       # Ép Camera cấp 30 FPS
        
        self.running = True
        
        # Hàng đợi DUY NHẤT 1 FRAME (Overwrite/No Buffer): ĐỂ WEB STREAM LIVE KHÔNG ĐỘ TRỄ!
        self.raw_frame_queue = Queue(maxsize=1)
        self.push_queue = Queue(maxsize=1) 
        
        self.session = requests.Session()
        
        # 3. CHẶT LUỒNG NETWORK RA KHỎI LUỒNG INFERENCE
        threading.Thread(target=self._capture_worker, daemon=True).start()
        threading.Thread(target=self._inference_worker, daemon=True).start()
        threading.Thread(target=self._push_worker, daemon=True).start()

    def _capture_worker(self):
        """Luồng 1: Đọc Camera Direct. Gần 0ms delay"""
        while self.running:
            ret, frame = self.cap.read()
            if not ret:
                time.sleep(0.005) # Sửa lại 0.005 để bám sát fps camera hơn
                continue
            
            if self.raw_frame_queue.full():
                try: self.raw_frame_queue.get_nowait()
                except: pass
            self.raw_frame_queue.put(frame)

    def _inference_worker(self):
        """Luồng 2: Thuần YOLO AI, không một dòng Code Network rác làm kẹt"""
        prev_time = time.time()
        while self.running:
            try:
                frame = self.raw_frame_queue.get(timeout=1.0)
                
                alert = "ok"
                boxes = []
                
                if model:
                    # Chạy AI. Sửa lỗi imgsz=640 để phòng ONNX crash, và bỏ "half=" để phòng CPU Fallback crash Windows
                    results = model.predict(
                        frame, 
                        conf=0.25, 
                        imgsz=640, 
                        verbose=False, 
                        device=device
                    )[0]
                    
                    if results.boxes:
                        for b in results.boxes:
                            cls = int(b.cls[0])
                            label = "fire" if cls == 0 else "smoke"
                            alert = "critical" if label == "fire" else "warning"
                            x1, y1, x2, y2 = map(int, b.xyxy[0])
                            conf = float(b.conf[0])
                            boxes.append({"class": label, "confidence": conf, "bbox": [x1, y1, x2, y2]})
                            
                            color = (0, 0, 255) if label == "fire" else (0, 215, 255)
                            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
                            cv2.putText(frame, f"{label.upper()} {conf:.2f}", (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

                # FPS Model thuần
                curr_time = time.time()
                fps = int(1.0 / (curr_time - prev_time)) if (curr_time - prev_time) > 0 else 0
                prev_time = curr_time
                
                # Hiển thị thông số FPS 
                hardware_text = "GPU CUDA (FP32)" if device == "cuda" else "CPU"
                model_type = "OpenVINO" if "_openvino" in model_path else "ONNX" if ".onnx" in model_path else "PyTorch"
                status_text = f"FPS: {fps} | Dvc: {hardware_text} | Mdl: {model_type}"
                
                cv2.putText(frame, status_text, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 3)
                cv2.putText(frame, status_text, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
                
                cv2.imshow("🚀 Turbo AI Camera - Realtime View", frame)
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    self.running = False
                    break

                # Chuyển qua hàng đợi Network 
                if self.push_queue.full():
                    try: self.push_queue.get_nowait()
                    except: pass
                # Truyền bản sao sang thread Push
                self.push_queue.put((frame.copy(), alert, fps, boxes))

            except Empty:
                continue
            except Exception as e:
                logger.error(f"Inference Lỗi: {e}")

    def _push_worker(self):
        """Luồng 3: Push Siêu Việt bằng ThreadPool (Bắn 30 API/giây không thèm đợi Server trả về)"""
        import concurrent.futures
        
        # Tạo 5 làn đường cao tốc (Threads) để vứt ảnh lên Server cùng lúc
        executor = concurrent.futures.ThreadPoolExecutor(max_workers=5)
        
        def _shoot_payload(frame, alert, fps, boxes):
            try:
                # Ép ảnh nhỏ xíu bằng thuật toán NEAREST nhanh nhất thế giới để đạt 0ms CPU time
                small_frame = cv2.resize(frame, (480, 360), interpolation=cv2.INTER_NEAREST)
                ok, jpg = cv2.imencode(".jpg", small_frame, [int(cv2.IMWRITE_JPEG_QUALITY), 45])
                if ok:
                    payload = {
                        "node_id": self.node_id,
                        "node_name": NODE_NAME,
                        "alert_level": alert,
                        "fps": fps,
                        "bboxes": boxes,
                        "timestamp": time.strftime("%H:%M:%S")
                    }
                    # Bắn Data THÔ (Raw Bytes) trực tiếp không gói ghém Multipart để Server khỏi mất công giải nén
                    self.session.post(
                        f"{CENTRAL_SERVER_URL}/api/nodes/push_data",
                        headers={"X-Telemetry": json.dumps(payload), "Content-Type": "image/jpeg"},
                        data=jpg.tobytes(),
                        timeout=0.3 # Siêu tốc, ping > 300ms thì vứt hình
                    )
            except Exception:
                pass 
                
        while self.running:
            try:
                # Luôn móc tấm ảnh RẤT MỚI NHẤT khỏi Queue, bỏ qua những tấm cũ
                frame, alert, fps, boxes = self.push_queue.get(timeout=1.0)
                
                # Giao cho lính vác ảnh chạy lên Cloud ngay lập tức, Luồng 3 quay lại đợi ảnh mới liền!
                executor.submit(_shoot_payload, frame, alert, fps, boxes)
                
            except Empty:
                continue
            except Exception:
                pass

if __name__ == "__main__":
    logger.info("🚀 ĐANG KHỞI ĐỘNG HỆ THỐNG PHÂN TÁCH LUỒNG + USB CAMERA TỐI ƯU")
    camera = TurboCameraStream(NODE_ID, CAMERA_SOURCE)
    
    try:
        while camera.running:
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("🛑 Người dùng yêu cầu dừng. Đang ngắt tức thì...")
        camera.running = False
        import os
        os._exit(0) # Chém đứt toàn bộ ThreadPool đang chờ mạng, tắt lập tức 0ms!
