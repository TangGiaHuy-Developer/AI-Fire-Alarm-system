import 'package:flutter/material.dart';

class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('SỰ CỐ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logovhu.png'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: const Color(0xFF1E293B).withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('Đang xử lý', 0),
          _buildTabItem('Đã giải quyết', 1),
          _buildTabItem('Tất cả', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 16),
          _buildPrimaryIncidentCard(),
          const SizedBox(height: 16),
          _buildSecondaryIncidentCard(),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Đã giải quyết gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildResolvedIncidentCard('#INC-000 - Báo giả', 'Hành lang T1', '10:15:00 | 24/10/2023'),
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tất cả sự cố', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildPrimaryIncidentCard(),
          const SizedBox(height: 16),
          _buildSecondaryIncidentCard(),
          const SizedBox(height: 16),
          _buildResolvedIncidentCard('#INC-000 - Báo giả', 'Hành lang T1', '10:15:00 | 24/10/2023'),
        ],
      );
    }
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Nhật ký sự kiện gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text('Cảnh báo cao', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPrimaryIncidentCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/cctv_view_of_a_kitchen_with_a_small_controlled_fire_simulation.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: const Text('LIVE: CAM-04', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('#INC-001 - Phát hiện Cháy/Khói', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Kho A - Tầng 2, Khu vực Phía Tây', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red.withOpacity(0.2))),
                      child: const Text('KHẨN CẤP', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('THỜI GIAN', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text('14:20:05 | 24/10/2023', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('THIẾT BỊ', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text('Hikvision Pro-X', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _showHandleIncidentDialog(context),
                        child: const Text('XỬ LÝ NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF334155)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _showIncidentDetailsBottomSheet(context),
                      child: const Text('CHI TIẾT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryIncidentCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/cctv_view_of_a_warehouse_interior_with_shelves_and_boxes.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('#INC-002 - Phát hiện Khói', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(border: Border.all(color: Colors.orange.withOpacity(0.3)), borderRadius: BorderRadius.circular(4)),
                      child: const Text('TRUNG BÌNH', style: TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Kho hàng xuất | 13:45:12', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () {},
                      child: const Text('Xem lại video', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () {},
                      child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolvedIncidentCard(String title, String location, String time) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$location | $time', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHandleIncidentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Xử lý sự cố #INC-001', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bạn có chắc chắn muốn đánh dấu sự cố này là đã xử lý không?', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ghi chú (tùy chọn)',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sự cố đã được xử lý'), backgroundColor: Colors.green));
              },
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showIncidentDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chi tiết sự cố #INC-001', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDetailRow('Loại sự cố', 'Phát hiện Cháy/Khói'),
              _buildDetailRow('Vị trí', 'Kho A - Tầng 2, Khu vực Phía Tây'),
              _buildDetailRow('Thời gian', '14:20:05 | 24/10/2023'),
              _buildDetailRow('Thiết bị', 'Hikvision Pro-X (CAM-04)'),
              _buildDetailRow('Mức độ', 'KHẨN CẤP', isAlert: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAlert = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: isAlert ? Colors.red : Colors.white, fontSize: 14, fontWeight: isAlert ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
