import warehouseImg from "@assets/generated_images/cctv_view_of_a_warehouse_interior_with_shelves_and_boxes.png";
import officeImg from "@assets/generated_images/cctv_view_of_a_modern_office_corridor.png";
import parkingImg from "@assets/generated_images/cctv_view_of_an_underground_parking_lot.png";
import serverImg from "@assets/generated_images/cctv_view_of_a_server_room_with_racks.png";
import fireImg from "@assets/generated_images/cctv_view_of_a_kitchen_with_a_small_controlled_fire_simulation.png";

export type CameraStatus =
  | "ok"
  | "warning"
  | "critical"
  | "offline"
  | "disconnected";

export interface Camera {
  id: string;
  name: string;
  location: string;
  status: CameraStatus;
  image: string;
  fps: number;
  latency: number;
  confidence?: number;
  detectedObject?: "Smoke" | "Fire" | null;
  buildingId?: string;
  floorId?: string;
  lat?: number; // Specific coordinates for the camera
  lng?: number;
}

export interface LogEntry {
  id: string;
  timestamp: string;
  camera: string;
  type: "INFO" | "WARNING" | "CRITICAL" | "ERROR";
  message: string;
}

export interface Floor {
  id: string;
  name: string;
  level: number;
}

export interface Building {
  id: string;
  name: string;
  floors: Floor[];
  lat: number;
  lng: number;
}

export const BUILDINGS: Building[] = [
  {
    id: "B1",
    name: "Trụ sở Chính",
    lat: 10.854,
    lng: 106.799,
    floors: [
      { id: "F1", name: "Tầng Trệt", level: 0 },
      { id: "F2", name: "Tầng 2", level: 1 },
      { id: "F3", name: "Tầng 3", level: 2 },
    ],
  },
  {
    id: "B2",
    name: "Trung tâm Logistics",
    lat: 10.855,
    lng: 106.8005,
    floors: [
      { id: "LG", name: "Tầng Hậu cần", level: 0 },
      { id: "B1", name: "Bãi xe Hầm", level: -1 },
    ],
  },
  {
    id: "B3",
    name: "Khu Sản Xuất",
    lat: 10.853,
    lng: 106.801,
    floors: [
      { id: "P1", name: "Xưởng Lắp Ráp", level: 1 },
      { id: "P2", name: "Kho Nguyên Liệu", level: 0 },
    ],
  },
];

export const CAMERAS: Camera[] = [
  {
    id: "CAM-01",
    name: "Kho Chính",
    location: "Khu A - Hậu cần",
    status: "ok",
    image: warehouseImg,
    fps: 24,
    latency: 45,
    detectedObject: null,
    buildingId: "B2",
    floorId: "LG",
    lat: 10.8551,
    lng: 106.8006,
  },
  {
    id: "CAM-02",
    name: "Hành lang Văn phòng",
    location: "Tầng 2 - Cánh Đông",
    status: "ok",
    image: officeImg,
    fps: 30,
    latency: 32,
    detectedObject: null,
    buildingId: "B1",
    floorId: "F2",
    lat: 10.8541,
    lng: 106.7991,
  },
  {
    id: "CAM-03",
    name: "Bãi xe B1",
    location: "Tầng hầm 1",
    status: "warning",
    image: parkingImg,
    fps: 18,
    latency: 120,
    confidence: 78,
    detectedObject: "Smoke",
    buildingId: "B2",
    floorId: "B1",
    lat: 10.8549,
    lng: 106.8004,
  },
  {
    id: "CAM-04",
    name: "Phòng Máy chủ",
    location: "Khu An ninh C",
    status: "ok",
    image: serverImg,
    fps: 60,
    latency: 15,
    detectedObject: null,
    buildingId: "B1",
    floorId: "F3",
    lat: 10.8539,
    lng: 106.7989,
  },
  {
    id: "CAM-05",
    name: "Nhà ăn Bếp",
    location: "Tầng Trệt",
    status: "critical",
    image: fireImg,
    fps: 28,
    latency: 24,
    confidence: 96,
    detectedObject: "Fire",
    buildingId: "B1",
    floorId: "F1",
    lat: 10.8542,
    lng: 106.7992,
  },
  {
    id: "CAM-06",
    name: "Cổng Bảo vệ",
    location: "Cổng Chính",
    status: "disconnected",
    image: "", // No image for disconnected
    fps: 0,
    latency: 0,
    detectedObject: null,
    buildingId: "B1-01",
    floorId: "M1",
    lat: 10.8538,
    lng: 106.7995,
  },
  {
    id: "CAM-07",
    name: "Kho Lạnh",
    location: "Khu B - Logistics",
    status: "ok",
    image: warehouseImg,
    fps: 25,
    latency: 40,
    detectedObject: null,
    buildingId: "B2",
    floorId: "LG",
    lat: 10.8552,
    lng: 106.8003,
  },
  {
    id: "CAM-08",
    name: "Dây chuyền 1",
    location: "Xưởng Lắp Ráp",
    status: "ok",
    image: warehouseImg,
    fps: 30,
    latency: 20,
    detectedObject: null,
    buildingId: "B3",
    floorId: "P1",
    lat: 10.8531,
    lng: 106.8011,
  },
  {
    id: "CAM-09",
    name: "Cửa Kho Nguyên Liệu",
    location: "Kho Nguyên Liệu",
    status: "warning",
    image: warehouseImg,
    fps: 22,
    latency: 55,
    confidence: 65,
    detectedObject: "Smoke",
    buildingId: "B3",
    floorId: "P2",
    lat: 10.8529,
    lng: 106.8009,
  },
];

export const MOCK_LOGS: LogEntry[] = [
  {
    id: "1",
    timestamp: "10:32:15",
    camera: "CAM-05",
    type: "CRITICAL",
    message: "PHÁT HIỆN LỬA - Độ tin cậy 96%",
  },
  {
    id: "2",
    timestamp: "10:32:12",
    camera: "CAM-05",
    type: "WARNING",
    message: "Phát hiện dấu hiệu nhiệt tiềm ẩn",
  },
  {
    id: "3",
    timestamp: "10:31:45",
    camera: "CAM-03",
    type: "WARNING",
    message: "Phát hiện khói - Độ tin cậy 78%",
  },
  {
    id: "4",
    timestamp: "10:30:00",
    camera: "SYSTEM",
    type: "INFO",
    message: "Kiểm tra sức khỏe hệ thống định kỳ đạt",
  },
  {
    id: "5",
    timestamp: "10:28:11",
    camera: "CAM-01",
    type: "INFO",
    message: "Phát hiện chuyển động tại Khu A",
  },
  {
    id: "6",
    timestamp: "10:15:00",
    camera: "SYSTEM",
    type: "INFO",
    message: "Sao lưu cơ sở dữ liệu hoàn tất",
  },
  {
    id: "7",
    timestamp: "09:45:00",
    camera: "CAM-06",
    type: "ERROR",
    message: "Mất kết nối tín hiệu camera",
  },
  {
    id: "8",
    timestamp: "09:44:55",
    camera: "CAM-06",
    type: "WARNING",
    message: "Tín hiệu chập chờn (High Latency)",
  },
  {
    id: "9",
    timestamp: "09:30:00",
    camera: "CAM-09",
    type: "WARNING",
    message: "Phát hiện khói nhẹ tại Kho Nguyên Liệu",
  },
];

export const ANALYTICS_DATA = [
  { name: "Tuần 1", accuracy: 82, falsePositives: 12 },
  { name: "Tuần 2", accuracy: 85, falsePositives: 10 },
  { name: "Tuần 3", accuracy: 88, falsePositives: 8 },
  { name: "Tuần 4", accuracy: 89, falsePositives: 6 },
  { name: "Tuần 5", accuracy: 92, falsePositives: 4 },
  { name: "Tuần 6", accuracy: 94, falsePositives: 3 },
  { name: "Tuần 7", accuracy: 96, falsePositives: 1.5 },
];
