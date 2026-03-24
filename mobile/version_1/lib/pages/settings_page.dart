import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double fireSensitivity = 0.85;
  double smokeSensitivity = 0.70;
  bool pushNotifications = true;
  bool audioAlerts = true;
  bool emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logovhu.png'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.psychology, 'Cấu hình AI'),
            const SizedBox(height: 16),
            _buildSliderCard('Ngưỡng tin cậy phát hiện lửa', 'Điều chỉnh độ nhạy cho cảnh báo lửa', fireSensitivity, (v) => setState(() => fireSensitivity = v)),
            const SizedBox(height: 16),
            _buildSliderCard('Ngưỡng tin cậy phát hiện khói', 'Điều chỉnh độ nhạy cho cảnh báo khói', smokeSensitivity, (v) => setState(() => smokeSensitivity = v)),
            const SizedBox(height: 32),
            _buildSectionHeader(Icons.notifications_active, 'Thông báo & Cảnh báo'),
            const SizedBox(height: 16),
            _buildToggleItem('Thông báo đẩy (Push)', 'Nhận cảnh báo trực tiếp trên điện thoại', pushNotifications, (v) => setState(() => pushNotifications = v)),
            _buildToggleItem('Cảnh báo âm thanh', 'Phát âm thanh báo động khi có sự cố', audioAlerts, (v) => setState(() => audioAlerts = v)),
            _buildToggleItem('Gửi Email khẩn cấp', 'Gửi ảnh hiện trường qua email đăng ký', emailAlerts, (v) => setState(() => emailAlerts = v)),
            const SizedBox(height: 32),
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildSliderCard(String title, String subtitle, double value, Function(double) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),
              Text('${(value * 100).toInt()}%', style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: value,
            activeColor: const Color(0xFF3B82F6),
            inactiveColor: const Color(0xFF3B82F6).withOpacity(0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF3B82F6),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
            radius: 24,
            child: const Icon(Icons.person, color: Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quản trị viên', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text('admin@firesentry.ai', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Đăng xuất', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}