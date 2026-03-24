// lib/models/models.dart

class Camera {
  final String id;
  final String name;
  final String location;
  final String? buildingId;
  final String? floorId;
  final double? lat;
  final double? lng;
  final String status; // 'ok', 'warning', 'critical', 'disconnected'
  final int fps;
  final int latency;
  final bool isReal;

  Camera({
    required this.id,
    required this.name,
    required this.location,
    this.buildingId,
    this.floorId,
    this.lat,
    this.lng,
    required this.status,
    this.fps = 0,
    this.latency = 0,
    this.isReal = false,
  });
}

// Dữ liệu thống nhất dùng chung (Mock Data)
final List<Camera> globalCameras = [
  Camera(
    id: '1',
    name: 'Camera Main Gate',
    location: 'Cổng chính - Lối vào',
    buildingId: 'B1',
    floorId: 'F1',
    lat: 10.8545,
    lng: 106.7998,
    status: 'ok',
    fps: 30,
    latency: 100,
    isReal: true,
  ),
  Camera(
    id: '2',
    name: 'Camera Warehouse',
    location: 'Nhà kho A - Khu vực hàng',
    buildingId: 'B2',
    floorId: 'F1',
    lat: 10.8547,
    lng: 106.8002,
    status: 'critical',
    fps: 25,
    latency: 150,
    isReal: false,
  ),
  Camera(
    id: '3',
    name: 'Camera Office',
    location: 'Tòa nhà văn phòng',
    buildingId: 'B3',
    floorId: 'F2',
    lat: 10.8543,
    lng: 106.7995,
    status: 'warning',
    fps: 20,
    latency: 200,
    isReal: false,
  ),
  Camera(
    id: '4',
    name: 'Camera Parking',
    location: 'Bãi đỗ xe nhân viên',
    buildingId: 'B4',
    floorId: 'F1',
    lat: 10.8548,
    lng: 106.7990,
    status: 'disconnected',
    fps: 0,
    latency: 0,
    isReal: false,
  ),
  Camera(
    id: '5',
    name: 'Camera Sảnh B1',
    location: 'Sảnh chờ khách',
    buildingId: 'B1',
    floorId: 'F1',
    lat: 10.8546,
    lng: 106.7999,
    status: 'ok',
    fps: 28,
    latency: 90,
    isReal: false,
  ),
];