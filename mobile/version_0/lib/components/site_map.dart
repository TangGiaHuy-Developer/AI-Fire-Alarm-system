// lib/components/site_map.dart

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/camera_data.dart';

// ... (Giữ nguyên phần Animation Widgets: AnimatePing, AnimatePulse như cũ) ...
// Để tiết kiệm dòng, tôi giả định bạn giữ nguyên code Animation ở đây 
// (Nếu cần tôi sẽ paste lại, nhưng nó không thay đổi gì).
// ==========================================
// Copy lại class AnimatePing và AnimatePulse ở đây
// ==========================================
class AnimatePing extends StatefulWidget {
  final Widget child;
  final Color color;
  const AnimatePing({Key? key, required this.child, required this.color}) : super(key: key);
  @override
  State<AnimatePing> createState() => _AnimatePingState();
}
class _AnimatePingState extends State<AnimatePing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      ScaleTransition(scale: Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
          child: FadeTransition(opacity: Tween<double>(begin: 0.75, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color)))),
      widget.child]);
  }
}

class AnimatePulse extends StatefulWidget {
  final Widget child;
  const AnimatePulse({Key? key, required this.child}) : super(key: key);
  @override
  State<AnimatePulse> createState() => _AnimatePulseState();
}
class _AnimatePulseState extends State<AnimatePulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) { return FadeTransition(opacity: _animation, child: widget.child); }
}

// ==========================================
// MAIN SITE MAP WIDGET
// ==========================================

class SiteMap extends StatefulWidget {
  // Thay vì chỉ nhận building/floor, ta nhận thêm ID cụ thể để highlight
  final String? selectedBuilding;
  final String? selectedFloor;
  final String? highlightedCameraId; // <-- ID DUY NHẤT ĐỂ ACTIVE
  
  final Function(String?, String?) onSelectLocation; // Callback lọc danh sách
  final Function(String) onCameraSelected; // Callback khi click marker

  const SiteMap({
    Key? key,
    required this.selectedBuilding,
    required this.selectedFloor,
    required this.highlightedCameraId, 
    required this.onSelectLocation,
    required this.onCameraSelected,
  }) : super(key: key);

  @override
  State<SiteMap> createState() => _SiteMapState();
}

class _SiteMapState extends State<SiteMap> {
  late MapController _mapController;
  final LatLng _defaultCenter = const LatLng(10.8545, 106.7998);
  final double _defaultZoom = 16;
  bool _isMapReady = false;
  Timer? _mapUpdateTimer;
  bool _hasMapMoved = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isMapReady = true);
        _updateMapView();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SiteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật map nếu thay đổi bộ lọc building HOẶC thay đổi camera active
    if (widget.selectedBuilding != oldWidget.selectedBuilding ||
        widget.selectedFloor != oldWidget.selectedFloor ||
        widget.highlightedCameraId != oldWidget.highlightedCameraId) {
      _updateMapView();
    }
  }

  void _updateMapView() {
    if (!_isMapReady) return;
    _mapUpdateTimer?.cancel();
    _mapUpdateTimer = Timer(const Duration(milliseconds: 100), () {
      try {
        // Ưu tiên 1: Nếu có Camera ID cụ thể đang được chọn -> Zoom vào nó
        if (widget.highlightedCameraId != null) {
          final camera = globalCameras.firstWhere(
            (c) => c.id == widget.highlightedCameraId,
            orElse: () => globalCameras.first,
          );
           if (camera.lat != null && camera.lng != null) {
            _mapController.move(LatLng(camera.lat!, camera.lng!), 18);
            return; // Dừng, không check building nữa
          }
        }

        // Ưu tiên 2: Nếu chỉ chọn Building -> Zoom vào camera đầu tiên của Building đó
        if (widget.selectedBuilding != null) {
          final camera = globalCameras.firstWhere(
            (c) => c.buildingId == widget.selectedBuilding,
            orElse: () => globalCameras.first,
          );
          if (camera.lat != null && camera.lng != null) {
            _mapController.move(LatLng(camera.lat!, camera.lng!), 18);
          }
        } else if (!_hasMapMoved) {
          // Mặc định
          _mapController.move(_defaultCenter, _defaultZoom);
        }
      } catch (e) {
        debugPrint('Error moving map: $e');
      }
    });
  }

  @override
  void dispose() {
    _mapUpdateTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  // --- Bottom Sheet Logic ---
  void _showCameraBottomSheet(Camera camera) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(camera),
    );
  }

  Widget _buildBottomSheetContent(Camera camera) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (camera.status) {
      case 'critical':
        statusColor = Colors.red; statusIcon = Icons.local_fire_department; statusText = 'CRITICAL'; break;
      case 'warning':
        statusColor = Colors.yellow; statusIcon = Icons.warning; statusText = 'WARNING'; break;
      case 'disconnected':
        statusColor = Colors.grey; statusIcon = Icons.wifi_off; statusText = 'DISCONNECTED'; break;
      default:
        statusColor = Colors.green; statusIcon = Icons.check_circle; statusText = 'OK';
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            border: const Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [const Icon(Icons.videocam, size: 22, color: Colors.white), const SizedBox(width: 10), Text(camera.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.2), border: Border.all(color: statusColor), borderRadius: BorderRadius.circular(6)),
                    child: Row(children: [Icon(statusIcon, size: 12, color: statusColor), const SizedBox(width: 4), Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold))]),
                  ),
                ],
              ),
              const SizedBox(height: 20), Divider(color: Colors.white10, height: 1), const SizedBox(height: 20),
              _buildInfoRow(Icons.location_on, 'Vị trí', camera.location),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.business, 'Khu vực', '${camera.buildingId ?? "N/A"} - ${camera.floorId ?? "N/A"}'),
              if (camera.fps > 0) ...[const SizedBox(height: 16), _buildInfoRow(Icons.speed, 'Hiệu năng', 'FPS: ${camera.fps} | Latency: ${camera.latency}ms')],
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: () => Navigator.pop(context), icon: const Icon(Icons.play_circle_fill), label: const Text("XEM LIVE STREAM"))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: Colors.grey[400])), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)), const SizedBox(height: 2), Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))])]);
  }

  // --- Map & Marker Rendering ---
  
  Widget _buildMarkerIcon(Camera camera, bool isSelected) {
    // SỬA ĐỔI: isSelected bây giờ chỉ true nếu ID trùng khớp chính xác
    final size = isSelected ? 32.0 : 24.0;
    Color baseColor;
    switch (camera.status) {
      case 'critical': baseColor = Colors.red; break;
      case 'warning': baseColor = Colors.yellow; break;
      case 'disconnected': baseColor = Colors.grey; break;
      default: baseColor = Colors.green;
    }

    Widget coreMarker = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.2),
        shape: BoxShape.circle,
        // Chỉ hiện Border trắng nếu đang được chọn
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: (camera.status == 'ok' || camera.status == 'disconnected')
            ? [BoxShadow(color: baseColor.withOpacity(0.5), blurRadius: 8)]
            : null,
      ),
      child: Center(
        child: Container(
          width: isSelected ? 18 : 12,
          height: isSelected ? 18 : 12,
          decoration: BoxDecoration(
            color: baseColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: camera.status == 'disconnected' ? Center(child: Text('!', style: TextStyle(color: Colors.white, fontSize: isSelected ? 10 : 8, fontWeight: FontWeight.bold))) : null,
        ),
      ),
    );

    // Chỉ chạy Animation nếu status đặc biệt VÀ (được chọn HOẶC là critical)
    // Hoặc bạn có thể quy định: Critical luôn ping, nhưng Selected thì có thêm border.
    // Ở đây tôi giữ logic: Critical/Warning luôn có hiệu ứng, nhưng size sẽ to hơn nếu Selected
    if (camera.status == 'critical') {
      return SizedBox(width: size * 2.5, height: size * 2.5, child: AnimatePing(color: Colors.red, child: coreMarker));
    } else if (camera.status == 'warning') {
      return AnimatePulse(child: coreMarker);
    }
    return coreMarker;
  }

  Widget _buildLegend() {
    return Positioned(
      bottom: 16, left: 16,
      child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLegendItem(Colors.red, 'Nguy hiểm'), const SizedBox(height: 6), _buildLegendItem(Colors.yellow, 'Cảnh báo'), const SizedBox(height: 6), _buildLegendItem(Colors.blue, 'Hoạt động'), const SizedBox(height: 6), _buildLegendItem(Colors.grey, 'Mất tín hiệu')])),
    );
  }
  Widget _buildLegendItem(Color color, String text) { return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 8), Text(text, style: const TextStyle(color: Colors.white, fontSize: 10))]); }

  void _toggleExpand() {
    // Lưu lại state hiện tại để truyền vào dialog
    String? tempSelectedBuilding = widget.selectedBuilding;
    String? tempSelectedFloor = widget.selectedFloor;
    String? tempHighlightedId = widget.highlightedCameraId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            backgroundColor: Colors.transparent, insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,
              child: _buildMapContent(
                fullscreen: true,
                activeBuildingId: tempSelectedBuilding,
                activeFloorId: tempSelectedFloor,
                activeCameraId: tempHighlightedId, // Truyền ID vào dialog
                onCustomSelect: (bId, fId, cId) { // Nhận thêm Camera ID
                  setStateDialog(() {
                    tempSelectedBuilding = bId;
                    tempSelectedFloor = fId;
                    tempHighlightedId = cId;
                  });
                  // Gọi callback ra ngoài Dashboard để đồng bộ
                  widget.onSelectLocation(bId, fId);
                  if (cId != null) widget.onCameraSelected(cId);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapContent({
    bool fullscreen = false,
    String? activeBuildingId,
    String? activeFloorId,
    String? activeCameraId, // Tham số mới
    Function(String?, String?, String?)? onCustomSelect, // Callback mới
  }) {
    // Dùng biến local (nếu trong dialog) hoặc biến widget (nếu ngoài)
    final currentCameraId = activeCameraId ?? widget.highlightedCameraId;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(center: _defaultCenter, zoom: _defaultZoom, interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate, onMapReady: () { if (mounted) setState(() => _isMapReady = true); }),
          children: [
            TileLayer(urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', subdomains: const ['a', 'b', 'c'], userAgentPackageName: 'com.example.app'),
            MarkerLayer(
              markers: globalCameras
                  .where((camera) => camera.lat != null && camera.lng != null)
                  .map((camera) {
                    // FIX: So sánh chính xác theo ID
                    final isSelected = camera.id == currentCameraId;
                    
                    return Marker(
                      width: 60, height: 60,
                      point: LatLng(camera.lat!, camera.lng!),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Khi click Marker -> Gửi ID ra ngoài
                          if (onCustomSelect != null) {
                            onCustomSelect(camera.buildingId, camera.floorId, camera.id);
                          } else {
                            widget.onSelectLocation(camera.buildingId, camera.floorId);
                            widget.onCameraSelected(camera.id);
                          }
                          _showCameraBottomSheet(camera);
                        },
                        child: Center(child: _buildMarkerIcon(camera, isSelected)),
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
        ),
        if (!fullscreen) _buildLegend(),
        Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))), child: Row(children: [const Icon(Icons.navigation, size: 16, color: Colors.blueAccent), const SizedBox(width: 8), const Text('HỆ THỐNG ĐỊA LÝ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'))]))),
        Positioned(top: 16, right: 16, child: GestureDetector(onTap: () { if (fullscreen) { Navigator.of(context).pop(); } else { _toggleExpand(); } }, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))), child: Icon(fullscreen ? Icons.fullscreen_exit : Icons.fullscreen, size: 20, color: Colors.white)))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildMapContent()));
  }
}