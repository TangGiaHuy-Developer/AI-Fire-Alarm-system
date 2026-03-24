import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('GIÁM SÁT', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logovhu.png'),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMapSection(),
            _buildLiveFeedsSection(),
            _buildAlertsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SƠ ĐỒ TÒA NHÀ', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text('Hoạt động', style: TextStyle(color: Colors.green, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
            ),
            child: Stack(
              children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(12),
                   child: Image.asset(
                     'assets/images/digital_blue_wireframe_blueprint_of_a_modern_tech_campus_building_layout.png',
                     width: double.infinity,
                     height: double.infinity,
                     fit: BoxFit.cover,
                   ),
                 ),
                 Positioned(
                   bottom: 12,
                   right: 12,
                   child: Column(
                     children: [
                       _buildMapToolBtn(Icons.zoom_in),
                       const SizedBox(height: 8),
                       _buildMapToolBtn(Icons.layers),
                     ],
                   ),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapToolBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildLiveFeedsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('LIVE FEEDS (4)', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text('Xem tất cả ', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12)),
                    Icon(Icons.arrow_forward, color: Color(0xFF3B82F6), size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 16 / 9,
            children: [
              _buildFeedCard('Sảnh chính A1', 'CAM_01', 'assets/images/cctv_view_of_a_modern_office_corridor.png'),
              _buildFeedCard('Khu vực bãi xe', 'CAM_02', 'assets/images/cctv_view_of_an_underground_parking_lot.png'),
              _buildFeedCard('Kho hàng xuất', 'CAM_03', 'assets/images/cctv_view_of_a_warehouse_interior_with_shelves_and_boxes.png'),
              _buildFeedCard('Phòng họp tầng 5', 'CAM_04', 'assets/images/cctv_view_of_a_server_room_with_racks.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard(String title, String subtitle, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.1)),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(2)),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 6),
                  SizedBox(width: 4),
                  Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                Text('14:23:45 | $subtitle', style: const TextStyle(color: Colors.grey, fontSize: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('THÔNG BÁO GẦN ĐÂY', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          _buildAlertItem(Icons.motion_photos_on, 'Phát hiện chuyển động', 'Cam 02 - 14:20:12'),
          const SizedBox(height: 8),
          _buildAlertItem(Icons.person_search, 'Nhận diện khuôn mặt lạ', 'Sảnh A1 - 14:15:05'),
        ],
      ),
    );
  }

  Widget _buildAlertItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}