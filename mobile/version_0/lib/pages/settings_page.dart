import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  _buildSettingItem('Tên Hệ thống', 'DeepBlue FireGuard HQ'),
                  _buildSettingItem('Vị trí', 'Tòa nhà A, Khu Công nghệ'),
                  _buildSettingItem('Email Quản trị', 'admin@deepblue.ai'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Lưu Thay đổi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFF2C2C2C),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}