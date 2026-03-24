# 🔥 AI Training for Fire Detection (Small Model Demo)

Dự án demo huấn luyện **YOLOv8 (mô hình nhỏ)** để **phát hiện lửa từ video**, bao gồm:

- Tách frame từ video
- Gán nhãn ảnh bằng **LabelMe**
- Convert LabelMe (JSON) → YOLO format
- Chia dataset train / validation
- Huấn luyện & test mô hình

---

## 📦 Cài đặt môi trường

> ⚠️ Khuyến nghị dùng **CPU**  
> Nếu không thêm `--extra-index-url`, pip có thể tải nhầm bản CUDA.

```bash
pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu
```

## 📁 Cấu trúc thư mục

```bash
fire_ai/
├── videos/
├── images/
│ ├── train/
│ └── val/
├── labels/
│ ├── train/
│ └── val/
├── scripts/
│ ├── extract_frames.py
│ ├── labelme_to_yolo.py
│ └── split_dataset.py
├── data.yaml
└── README.md
```

## 🚀 Quy trình thực hiện

Bước 1: Thêm video
Copy video vào thư mục:
videos/

---

Bước 2: Tách frame từ video

```bash
python ./scripts/extract_frames.py
```

Ảnh sẽ được lưu vào thư mục images/

---

Bước 3:🏷️ Gán nhãn ảnh bằng LabelMe
labelme
Trong LabelMe:
Open Dir → D:\Project_AI\fire_ai\images
Create Rectangle
Vẽ box quanh vùng có lửa
Nhập label: lửa
Save

## 📌 LabelMe lưu nhãn dạng .json cùng thư mục với ảnh

Bước 4: Convert LabelMe → YOLO

```bash
python ./scripts/labelme_to_yolo.py
```

---

Bước 5: Tạo thư mục train / val
mkdir images\train
mkdir images\val
mkdir labels\train
mkdir labels\val

---

Bước 6: Chia dataset

```bash
python ./scripts/split_dataset.py
```

Train ≈ 80%
Val ≈ 20%

---

Bước 7: Tạo file data.yaml

```bash
path: .
train: images/train
val: images/val
names:
0: lửa
```

---

Bước 8: Train model

```bash
yolo task=detect mode=train model=yolov8n.pt data=data.yaml epochs=100 imgsz=640 batch=8
```

---

Bước 9: Test model

```bash
yolo task=detect mode=predict model=runs/detect/train4/weights/best.pt source=videos/fire1.mp4 conf=0.05

yolo task=detect mode=predict model=runs/detect/train4/weights/best.pt source=videos/fire2.mp4 conf=0.05

yolo task=detect mode=predict model=runs/detect/train6/weights/best.pt source=videos/test/fire2.mp4 conf=0.05
```

---

Bước 10: Xem kết quả
runs/detect/predict\*/

---

## ⚠️ Lưu ý

Dataset nhỏ → chỉ mang tính demo
Nên bổ sung ảnh không có lửa để giảm false positive
Có thể dùng model lớn hơn (yolov8s, yolov8m) để tăng độ chính xác

PS D:\Project_AI\fire_ai> pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
python - <<EOF
import torch
print(torch.cuda.is_available())
print(torch.cuda.device_count())
print(torch.cuda.get_device_name(0))
EOF

## 🧠 Công nghệ sử dụng

- Python 3.11
- OpenCV
- LabelMe
- Ultralytics YOLOv8
- PyTorch (CPU)
