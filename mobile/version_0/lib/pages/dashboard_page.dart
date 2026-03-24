// lib/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import '../models/camera_data.dart';
import '../components/site_map.dart'; 
import '../components/camera_card.dart';
import '../components/alert_panel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _selectedBuilding;
  String? _selectedFloor;
  
  String? _highlightedCameraId; 

  bool _showAlertPanel = false;
  Camera? _selectedCameraForOverlay; 
  final double kDefaultPadding = 20.0;

  List<Camera> get _filteredCameras {
    if (_selectedBuilding == null) {
      return globalCameras;
    }
    return globalCameras.where((cam) => cam.buildingId == _selectedBuilding).toList();
  }

  void _toggleAlertPanel() {
    setState(() => _showAlertPanel = !_showAlertPanel);
  }

  void _openCameraOverlay(Camera camera) {
    setState(() => _selectedCameraForOverlay = camera);
  }

  void _closeCameraOverlay() {
    setState(() => _selectedCameraForOverlay = null);
  }

  // Khi chọn location (Building/Floor)
  void _onLocationSelected(String? buildingId, String? floorId) {
    setState(() {
      _selectedBuilding = buildingId;
      _selectedFloor = floorId;
      // Không reset _highlightedCameraId ở đây nếu muốn giữ highlight cũ
      // Nhưng thường khi đổi building thì nên clear highlight cũ đi để tránh nhầm lẫn
      if (buildingId == null) _highlightedCameraId = null; 
    });
  }

  // Khi click trực tiếp vào 1 camera (từ Map hoặc List)
  void _onCameraSelected(String cameraId) {
    setState(() {
      _highlightedCameraId = cameraId;
      
      // Nếu click camera, có thể tự động set Building Filter theo camera đó
      final cam = globalCameras.firstWhere((c) => c.id == cameraId);
      if (cam.buildingId != null) {
         _selectedBuilding = cam.buildingId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayCameras = _filteredCameras;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- HEADER ---
                Container(
                  decoration: const BoxDecoration(color: Colors.black, border: Border(bottom: BorderSide(color: Colors.white10))),
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Trung tâm Điều hành', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text('Quản lý giám sát thời gian thực', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))])]),
                      Stack(children: [
                        ElevatedButton(onPressed: _toggleAlertPanel, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900.withOpacity(0.3), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.red.shade700))), child: const Row(children: [Icon(Icons.warning_amber, size: 20), SizedBox(width: 8), Text('CẢNH BÁO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))])),
                        Positioned(top: -2, right: -2, child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: const Color.fromARGB(255, 69, 52, 52), width: 2)), child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))
                      ]),
                    ],
                  ),
                ),

                // --- MAP SECTION ---
                Expanded(
                  flex: 4, 
                  child: Container(
                    margin: EdgeInsets.all(kDefaultPadding),
                    child: SiteMap(
                      selectedBuilding: _selectedBuilding,
                      selectedFloor: _selectedFloor,
                      highlightedCameraId: _highlightedCameraId, // Truyền ID cần highlight
                      onSelectLocation: _onLocationSelected,
                      onCameraSelected: _onCameraSelected, // Nhận sự kiện click marker
                    ),
                  ),
                ),

                Container(height: 1, color: Colors.white10, margin: EdgeInsets.symmetric(horizontal: kDefaultPadding)),

                // --- CAMERA LIST SECTION ---
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(kDefaultPadding, 16, kDefaultPadding, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedBuilding != null ? 'Camera tại Khu vực $_selectedBuilding' : 'Tất cả Camera Hệ thống', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              if (_selectedBuilding != null || _selectedFloor != null)
                                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade700)), child: TextButton(onPressed: () => _onLocationSelected(null, null), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), minimumSize: Size.zero), child: Row(children: [Icon(Icons.close, size: 14, color: Colors.grey.shade400), const SizedBox(width: 6), Text('Hiện tất cả', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))]))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: displayCameras.isEmpty 
                          ? const Center(child: Text("Không tìm thấy camera trong khu vực này", style: TextStyle(color: Colors.white54)))
                          : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, crossAxisSpacing: 16, mainAxisSpacing: 16),
                            itemCount: displayCameras.length,
                            itemBuilder: (context, index) {
                              final camera = displayCameras[index];
                              // Kiểm tra xem camera này có đang active trên map không để đổi màu Card (optional)
                              final isActive = camera.id == _highlightedCameraId;
                              
                              return GestureDetector(
                                // Khi click vào card -> active trên Map
                                onTap: () => _onCameraSelected(camera.id),
                                child: Container(
                                  // Hiệu ứng border khi active trong list (Optional)
                                  decoration: isActive ? BoxDecoration(border: Border.all(color: Colors.blue, width: 2), borderRadius: BorderRadius.circular(12)) : null,
                                  child: CameraCard(
                                    id: camera.id,
                                    name: camera.name,
                                    location: camera.location,
                                    status: camera.status,
                                    fps: camera.fps,
                                    latency: camera.latency,
                                    isReal: camera.isReal,
                                    onTap: () => _openCameraOverlay(camera), // Nút Play/Open mở full screen
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- ALERTS & OVERLAYS ---
            if (_showAlertPanel)
              AnimatedPositioned(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, right: 0, top: 0, bottom: 0, child: Container(width: 400, decoration: BoxDecoration(color: Colors.black, border: const Border(left: BorderSide(color: Colors.white10)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)]), child: Column(children: [Container(height: 70, padding: const EdgeInsets.symmetric(horizontal: 20), decoration: const BoxDecoration(color: Colors.black, border: Border(bottom: BorderSide(color: Colors.white10))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Row(children: [Icon(Icons.warning_amber, color: Colors.red, size: 24), SizedBox(width: 12), Text('CẢNH BÁO HỆ THỐNG', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]), IconButton(onPressed: _toggleAlertPanel, icon: const Icon(Icons.close, color: Colors.white, size: 24))])), const Expanded(child: AlertPanel())]))),
              
            if (_selectedCameraForOverlay != null) _buildFullCameraOverlay(),
          ],
        ),
      ),
    );
  }

  // (Giữ nguyên phần _buildFullCameraOverlay và _buildOverlayStat như code trước)
  Widget _buildFullCameraOverlay() {
    final cam = _selectedCameraForOverlay!;
    Color statusColor;
    switch (cam.status) {
      case 'critical': statusColor = Colors.red; break;
      case 'warning': statusColor = Colors.yellow; break;
      case 'disconnected': statusColor = Colors.grey; break;
      default: statusColor = Colors.green;
    }
    return Positioned.fill(child: Container(color: Colors.black.withOpacity(0.9), child: Stack(children: [Center(child: Container(width: MediaQuery.of(context).size.width * 0.9, height: MediaQuery.of(context).size.height * 0.8, decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24), boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 20, spreadRadius: 5)]), child: Column(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(cam.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(cam.location, style: TextStyle(color: Colors.grey[400], fontSize: 14))]), IconButton(onPressed: _closeCameraOverlay, icon: const Icon(Icons.close, color: Colors.white, size: 30))])), Expanded(child: Container(color: Colors.black, child: Center(child: Icon(Icons.videocam, size: 100, color: statusColor.withOpacity(0.5))))), Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildOverlayStat('TRẠNG THÁI', cam.status.toUpperCase(), statusColor), _buildOverlayStat('FPS', '${cam.fps}', Colors.blue), _buildOverlayStat('ĐỘ TRỄ', '${cam.latency} ms', cam.latency < 150 ? Colors.green : Colors.orange), _buildOverlayStat('TÍN HIỆU', cam.isReal ? 'LIVE' : 'REC', Colors.red)]))])))])));
  }

  Widget _buildOverlayStat(String label, String value, Color color) {
    return Column(children: [Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1)), const SizedBox(height: 5), Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace'))]);
  }
}