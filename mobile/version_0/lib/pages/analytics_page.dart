import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const List<Map<String, dynamic>> ANALYTICS_DATA = [
  {'name': "Tuần 1", 'accuracy': 82.0, 'falsePositives': 12.0},
  {'name': "Tuần 2", 'accuracy': 85.0, 'falsePositives': 10.0},
  {'name': "Tuần 3", 'accuracy': 88.0, 'falsePositives': 8.0},
  {'name': "Tuần 4", 'accuracy': 60.0, 'falsePositives': 6.0},
  {'name': "Tuần 5", 'accuracy': 92.0, 'falsePositives': 4.0},
  {'name': "Tuần 6", 'accuracy': 70.0, 'falsePositives': 3.0},
  {'name': "Tuần 7", 'accuracy': 100.0, 'falsePositives': 1.5},
];

const List<Map<String, dynamic>> MOCK_LOGS = [
  {'id': "1", 'timestamp': "10:32:15", 'camera': "CAM-05", 'type': "CRITICAL", 'message': "PHÁT HIỆN LỬA - Độ tin cậy 96%"},
  {'id': "2", 'timestamp': "10:32:12", 'camera': "CAM-05", 'type': "WARNING", 'message': "Phát hiện dấu hiệu nhiệt tiềm ẩn"},
  {'id': "3", 'timestamp': "10:31:45", 'camera': "CAM-03", 'type': "WARNING", 'message': "Phát hiện khói - Độ tin cậy 78%"},
  {'id': "4", 'timestamp': "10:30:00", 'camera': "SYSTEM", 'type': "INFO", 'message': "Kiểm tra sức khỏe hệ thống định kỳ đạt"},
  {'id': "5", 'timestamp': "10:28:11", 'camera': "CAM-01", 'type': "INFO", 'message': "Phát hiện chuyển động tại Khu A"},
  {'id': "6", 'timestamp': "10:15:00", 'camera': "SYSTEM", 'type': "INFO", 'message': "Sao lưu cơ sở dữ liệu hoàn tất"},
  {'id': "7", 'timestamp': "09:45:00", 'camera': "CAM-06", 'type': "ERROR", 'message': "Mất kết nối tín hiệu camera"},
  {'id': "8", 'timestamp': "09:44:55", 'camera': "CAM-06", 'type': "WARNING", 'message': "Tín hiệu chập chờn (High Latency)"},
  {'id': "9", 'timestamp': "09:30:00", 'camera': "CAM-09", 'type': "WARNING", 'message': "Phát hiện khói nhẹ tại Kho Nguyên Liệu"},
];

final List<Map<String, dynamic>> CAMERAS_MOCK = [
  {'status': 'ok'}, {'status': 'ok'}, {'status': 'warning'}, 
  {'status': 'ok'}, {'status': 'critical'}, {'status': 'disconnected'},
  {'status': 'ok'}, {'status': 'ok'}, {'status': 'warning'}
];

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late int totalCameras;
  late int activeCameras;
  late int criticalEvents;
  final double avgConfidence = 94.5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    totalCameras = CAMERAS_MOCK.length;
    activeCameras = CAMERAS_MOCK.where((c) => c['status'] != "disconnected").length;
    criticalEvents = MOCK_LOGS.where((l) => l['type'] == "CRITICAL").length;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16), 
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
              color: Colors.black, 
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Báo cáo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            Text('Giám sát PCCC', style: TextStyle(color: Colors.grey[400], fontSize: 11), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      tooltip: "24 Giờ qua",
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download, color: Colors.white, size: 20),
                      tooltip: "Xuất PDF",
                    ),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: "Tổng quan"),
                      Tab(text: "Hiệu năng"),
                      Tab(text: "Nhật ký"),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildPerformanceTab(),
                      _buildLogsTab(),
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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.count(
            crossAxisCount: 2, 
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3, 
            children: [
              _buildStatCard(
                title: 'Camera Active',
                value: '$activeCameras/$totalCameras',
                icon: Icons.visibility,
                iconColor: Colors.blue,
                subText: totalCameras - activeCameras > 0 
                  ? '${totalCameras - activeCameras} mất kết nối'
                  : 'Ổn định',
                subColor: totalCameras - activeCameras > 0 ? Colors.red : Colors.green,
              ),
              _buildStatCard(
                title: 'Cảnh báo',
                value: '$criticalEvents',
                icon: Icons.warning,
                iconColor: Colors.red,
                valueColor: Colors.red,
                subText: '+2 so với tuần trước',
              ),
              _buildStatCard(
                title: 'Độ chính xác',
                value: '$avgConfidence%',
                icon: Icons.bolt,
                iconColor: Colors.amber,
                valueColor: Colors.amber,
                subText: 'Tăng 2.5%',
              ),
              _buildStatCard(
                title: 'Uptime',
                value: '99.9%',
                icon: Icons.dns,
                iconColor: Colors.green,
                valueColor: Colors.green,
                subText: 'Hệ thống ổn định',
              ),
            ],
          ),
          
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Độ chính xác & Báo sai", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("Hiệu quả mô hình qua các tuần", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                
                SizedBox(
                  height: 250, 
                  child: _buildAreaChart(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Phân bổ Sự kiện", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildDistributionBar("Phát hiện Lửa", "12%", Colors.red, 0.12),
                const SizedBox(height: 16),
                _buildDistributionBar("Phát hiện Khói", "28%", Colors.orange, 0.28),
                const SizedBox(height: 16),
                _buildDistributionBar("Cảnh báo Nhiệt", "15%", Colors.yellow, 0.15),
                const SizedBox(height: 16),
                _buildDistributionBar("Thông tin Hệ thống", "45%", Colors.blue, 0.45),
                
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.security, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Text("Đánh giá An toàn", style: TextStyle(color: Colors.blue[400], fontWeight: FontWeight.bold, fontSize: 12))
                      ]),
                      const SizedBox(height: 4),
                      const Text(
                        "Hệ thống ổn định. Tỷ lệ phát hiện đúng cao (96%).",
                        style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column( 
        children: [
          _buildBigStatCard("Tốc độ xử lý (FPS)", "48", "FPS Trung bình", "Target: 30", Colors.blue),
          const SizedBox(height: 16),
          _buildBigStatCard("Độ trễ (Latency)", "120ms", "Độ trễ trung bình", "Realtime (<200ms)", Colors.green),
        ],
      ),
    );
  }

  Widget _buildLogsTab() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Nhật ký Hoạt động", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1, color: Colors.white10),
          
          Container(
            color: Colors.white.withOpacity(0.02),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(width: 70, child: Text("GIỜ", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                    SizedBox(width: 60, child: Text("NGUỒN", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                    SizedBox(width: 80, child: Text("LOẠI", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                    SizedBox(width: 150, child: Text("NỘI DUNG", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          
          Expanded(
            child: ListView.separated(
              itemCount: MOCK_LOGS.length,
              separatorBuilder: (c, i) => const Divider(height: 1, color: Colors.white10),
              itemBuilder: (context, index) {
                final log = MOCK_LOGS[index];
                return _buildLogItem(log);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    Color valueColor = Colors.white,
    String? subText,
    Color subColor = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70), overflow: TextOverflow.ellipsis)),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
          if (subText != null)
            Text(subText, style: TextStyle(fontSize: 10, color: subColor), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(String label, String pct, Color color, double percent) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
            Text(pct, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white10,
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildBigStatCard(String title, String value, String subtitle, String status, Color color) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(color: color, fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(height: 16),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
             decoration: BoxDecoration(
               color: color.withOpacity(0.1),
               borderRadius: BorderRadius.circular(6),
               border: Border.all(color: color.withOpacity(0.2)),
             ),
             child: Text(status, style: TextStyle(color: color, fontSize: 12)),
           )
        ],
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    Color badgeColor;
    Color badgeBg;
    IconData badgeIcon;

    switch (log['type']) {
      case 'CRITICAL':
        badgeColor = Colors.red;
        badgeBg = Colors.red.withOpacity(0.2);
        badgeIcon = Icons.warning;
        break;
      case 'WARNING':
        badgeColor = Colors.orange;
        badgeBg = Colors.orange.withOpacity(0.2);
        badgeIcon = Icons.error_outline;
        break;
      case 'ERROR':
        badgeColor = Colors.deepOrange;
        badgeBg = Colors.deepOrange.withOpacity(0.2);
        badgeIcon = Icons.wifi_off;
        break;
      default: 
        badgeColor = Colors.blue;
        badgeBg = Colors.blue.withOpacity(0.2);
        badgeIcon = Icons.info_outline;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 70, child: Text(log['timestamp'], style: TextStyle(color: Colors.grey[400], fontFamily: 'monospace', fontSize: 12))),
            SizedBox(width: 60, child: Text(log['camera'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12))),
            SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4), border: Border.all(color: badgeColor.withOpacity(0.3))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 8, color: badgeColor),
                      const SizedBox(width: 4),
                      Text(log['type'], style: TextStyle(color: badgeColor, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 150, child: Text(log['message'], style: TextStyle(color: Colors.grey[400], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < ANALYTICS_DATA.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'T${index + 1}', // Viết tắt Tuần -> T để đỡ tốn chỗ
                      style: const TextStyle(color: Colors.grey, fontSize: 10)
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (ANALYTICS_DATA.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: ANALYTICS_DATA.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['accuracy'])).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          LineChartBarData(
            spots: ANALYTICS_DATA.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['falsePositives'])).toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.red.withOpacity(0.3), Colors.red.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
      ),
    );
  }
}