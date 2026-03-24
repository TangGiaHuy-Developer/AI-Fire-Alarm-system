from flask import Flask, jsonify, request, Response, stream_with_context
from flask_cors import CORS
import time, logging, json, threading
from collections import deque

# ================= CONFIG =================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("central-gateway")

app = Flask(__name__)
# Tắt log hệ thống mạng để nhẹ CPU
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)
CORS(app)

# Registry lưu trữ thông tin & dữ liệu memory cực nhanh
edge_nodes = {}  
edge_frames = {} # node_id -> bytes
frame_conditions = {} # node_id -> threading.Condition() (Để truyền stream tức thì 0ms)
EVENT_LOGS = deque(maxlen=100)

@app.route("/api/nodes/push_data", methods=["POST"])
def push_data():
    """ 
    Kiến trúc PUSH: Nhận Pure Binary JPEG & Headers siêu tốc, Bỏ qua Multipart Parser rề rà của Flask.
    """
    telemetry_str = request.headers.get("X-Telemetry")
    if not telemetry_str:
        return jsonify({"error": "Missing telemetry header"}), 400
        
    try:
        data = json.loads(telemetry_str)
        node_id = data.get("node_id")
    except Exception as e:
        return jsonify({"error": "Invalid json telemetry"}), 400
        
    if node_id:
        data["last_seen"] = time.time()
        edge_nodes[node_id] = data
        
        # Đọc dữ liệu thô C-level trực tiếp từ RAM của OS (KHÔNG GÓI GHÉM, TỐC ĐỘ 0ms)
        frame_bytes = request.get_data()
        if frame_bytes:
            edge_frames[node_id] = frame_bytes
            # Bắn tín hiệu TỨC THÌ cho tất cả trình duyệt đang xem luồng stream này
            if node_id not in frame_conditions:
                frame_conditions[node_id] = threading.Condition()
            with frame_conditions[node_id]:
                frame_conditions[node_id].notify_all()
            
        # Log Event Tự động
        if data.get("alert_level") in ["critical", "warning"]:
            event = {
                "id": f"{node_id}-{int(time.time())}",
                "type": "CRITICAL" if data["alert_level"] == "critical" else "WARNING",
                "camera": data.get("node_name", node_id),
                "message": f"Phát hiện {'LỬA' if data['alert_level'] == 'critical' else 'KHÓI'}",
                "timestamp": data.get("timestamp", time.strftime("%H:%M:%S")),
                "confirmed": None
            }
            if not EVENT_LOGS or EVENT_LOGS[0]["camera"] != event["camera"] or (time.time() - float(EVENT_LOGS[0]["id"].split("-")[1]) > 5):
                EVENT_LOGS.appendleft(event)
                
    return jsonify({"status": "ok"})

@app.route("/detection/<cam_id>")
def get_detection(cam_id):
    node = edge_nodes.get(cam_id)
    if not node:
        return jsonify({"alert_level": "disconnected", "fps": 0, "bboxes": []})
        
    if time.time() - node.get("last_seen", 0) > 5.0:
        return jsonify({"alert_level": "disconnected", "fps": 0, "bboxes": []})

    return jsonify(node)

@app.route("/stream/<cam_id>")
def stream_proxy(cam_id):
    """ 
    Đọc Cache trên RAM và trả ngay Multipart JPEG.
    Loại bỏ mọi lớp đệm (Buffering) của Flask để đạt 0ms Delay.
    """
    def generate():
        if cam_id not in frame_conditions:
            frame_conditions[cam_id] = threading.Condition()
            
        last_frame_bytes = None
        while True:
            with frame_conditions[cam_id]:
                # Chờ cho đến khi frame mới được đẩy lên
                frame_conditions[cam_id].wait(timeout=1.0)
                
            frame_bytes = edge_frames.get(cam_id)
            if frame_bytes and frame_bytes != last_frame_bytes:
                # Ép Werkzeug xả (flush) dữ liệu thẳng mặt Client Trình Duyệt ngay lập tức
                yield b"--frame\r\nContent-Type: image/jpeg\r\n\r\n" + frame_bytes + b"\r\n\r\n"
                last_frame_bytes = frame_bytes

    # Sử dụng direct mimetype passthrough, loại bỏ các Header thừa làm rác bộ đệm
    return Response(stream_with_context(generate()), mimetype="multipart/x-mixed-replace; boundary=frame", direct_passthrough=True)

@app.route("/api/events/latest")
def get_events():
    return jsonify(list(EVENT_LOGS))

@app.route("/api/events/confirm-true", methods=["POST"])
@app.route("/api/events/confirm-false", methods=["POST"])
def confirm_event():
    return jsonify({"ok": True})

if __name__ == "__main__":
    logger.info("🚀 CENTRAL GATEWAY (PORT 5000) HOẠT ĐỘNG KIẾN TRÚC PUSH TRÊN RAM")
    # Tắt luồng xử lý thừa để tăng hiệu năng tối đax