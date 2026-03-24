import 'package:flutter/material.dart';

class AlertPanel extends StatelessWidget {
  const AlertPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'title': 'CẢNH BÁO CHÁY',
        'location': 'Camera 1 - Tòa nhà A',
        'description': 'Phát hiện khói bất thường ở khu vực kho hàng',
        'time': '2 phút trước',
        'icon': Icons.local_fire_department,
        'color': Colors.red,
        'priority': 'critical',
      },
      {
        'title': 'MẤT KẾT NỐI',
        'location': 'Camera 3 - Tòa nhà B',
        'description': 'Mất tín hiệu trong 15 phút, kiểm tra đường truyền',
        'time': '10 phút trước',
        'icon': Icons.wifi_off,
        'color': Colors.yellow,
        'priority': 'warning',
      },
      {
        'title': 'XÂM NHẬP BẤT THƯỜNG',
        'location': 'Camera 5 - Kho hàng',
        'description': 'Phát hiện chuyển động ngoài giờ làm việc',
        'time': '25 phút trước',
        'icon': Icons.error,
        'color': Colors.orange,
        'priority': 'warning',
      },
      {
        'title': 'LỖI PHẦN CỨNG',
        'location': 'Camera 2 - Tòa nhà C',
        'description': 'Nhiệt độ camera cao bất thường (65°C)',
        'time': '1 giờ trước',
        'icon': Icons.thermostat,
        'color': Colors.red,
        'priority': 'critical',
      },
      {
        'title': 'MẤT ĐIỆN',
        'location': 'Camera 4 - Tầng hầm',
        'description': 'Mất nguồn điện, chuyển sang pin dự phòng',
        'time': '1 giờ 30 phút trước',
        'icon': Icons.power_off,
        'color': Colors.orange,
        'priority': 'warning',
      },
    ];

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Summary Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Nguy hiểm',
                  '2',
                  Colors.red,
                  Icons.dangerous,
                ),
                _buildStatCard(
                  'Cảnh báo',
                  '3',
                  Colors.yellow,
                  Icons.warning,
                ),
                _buildStatCard(
                  'Đang xử lý',
                  '1',
                  Colors.blue,
                  Icons.sync,
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Alerts List Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'TẤT CẢ CẢNH BÁO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Text(
                    'Tổng: ${alerts.length}',
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: alerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _buildAlertCard(alert);
              },
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900.withOpacity(0.3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.shade700),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 18),
                        const SizedBox(width: 8),
                        Text('Đánh dấu tất cả đã xử lý'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade700),
                    ),
                  ),
                  child: Icon(Icons.settings, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: alert['color'].withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Alert Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: alert['color'].withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: alert['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(alert['icon'], size: 20, color: alert['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'],
                        style: TextStyle(
                          color: alert['color'],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert['location'],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: alert['priority'] == 'critical'
                        ? Colors.red.withOpacity(0.2)
                        : Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: alert['priority'] == 'critical'
                          ? Colors.red
                          : Colors.yellow,
                    ),
                  ),
                  child: Text(
                    alert['priority'] == 'critical' ? 'NGUY HIỂM' : 'CẢNH BÁO',
                    style: TextStyle(
                      color: alert['priority'] == 'critical'
                          ? Colors.red
                          : Colors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Alert Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['description'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      alert['time'],
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: alert['color'].withOpacity(0.1),
                        foregroundColor: alert['color'],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: alert['color']),
                        ),
                      ),
                      child: Text(
                        'XEM CHI TIẾT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}