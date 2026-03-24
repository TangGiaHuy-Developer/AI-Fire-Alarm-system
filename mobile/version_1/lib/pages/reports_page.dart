import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('BÁO CÁO', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logovhu.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTabs(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabItem('Xu hướng', 0),
        _buildTabItem('Chi tiết', 1),
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      // Tab Xu hướng
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComparisonCard(),
          const SizedBox(height: 24),
          _buildInsightsComponent(),
        ],
      );
    } else {
      // Tab Chi tiết
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailedDataHeader(),
          const SizedBox(height: 16),
          _buildDataTable(),
        ],
      );
    }
  }

  Widget _buildComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SO SÁNH XU HƯỚNG', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Độ chính xác vs. Báo động giả', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('7 ngày qua ', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
              const Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 16),
                  Text(' 2.5%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 150,
            width: double.infinity,
            child: _buildTrendLineChart(),
          ),
          const SizedBox(height: 16),
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Độ chính xác (98.2%)', style: TextStyle(color: Colors.grey.shade300, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Báo động giả (1.8%)', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1, dashArray: [4, 4]);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold);
                switch (value.toInt()) {
                  case 0: return const Text('T2', style: style);
                  case 1: return const Text('T3', style: style);
                  case 2: return const Text('T4', style: style);
                  case 3: return const Text('T5', style: style);
                  case 4: return const Text('T6', style: style);
                  case 5: return const Text('T7', style: style);
                  case 6: return const Text('CN', style: style);
                  default: return const Text('');
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Độ chính xác (Màu xanh dương)
          LineChartBarData(
            spots: const [
              FlSpot(0, 8),
              FlSpot(1, 9),
              FlSpot(2, 7.5),
              FlSpot(3, 8.5),
              FlSpot(4, 9.5),
              FlSpot(5, 10),
              FlSpot(6, 9.8),
            ],
            isCurved: true,
            color: const Color(0xFF3B82F6),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Báo động giả (Màu xám)
          LineChartBarData(
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 1),
              FlSpot(2, 2.5),
              FlSpot(3, 1.5),
              FlSpot(4, 0.5),
              FlSpot(5, 0),
              FlSpot(6, 0.2),
            ],
            isCurved: true,
            color: Colors.grey.shade500,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [4, 4], // Đường nét đứt
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 12,
      ),
    );
  }

  Widget _buildDetailedDataHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Dữ liệu chi tiết', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 16, color: Color(0xFF3B82F6)),
          label: const Text('Xuất CSV', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTableColHeader('NGÀY', 2),
                _buildTableColHeader('SỰ KIỆN', 1),
                _buildTableColHeader('CHÍNH XÁC', 1),
              ],
            ),
          ),
          _buildTableRow('Hôm nay', '1,240', '99.1%'),
          _buildTableRow('Hôm qua', '1,150', '98.5%'),
          _buildTableRow('20/10/2023', '980', '97.8%'),
          _buildTableRow('19/10/2023', '1,420', '98.9%'),
        ],
      ),
    );
  }

  Widget _buildTableColHeader(String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTableRow(String date, String events, String accuracy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(date, style: TextStyle(color: Colors.grey.shade300, fontSize: 14))),
          Expanded(flex: 1, child: Text(events, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text(accuracy, style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildInsightsComponent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF334155).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF3B82F6), width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: Color(0xFF3B82F6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gợi ý tối ưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Độ chính xác tăng nhẹ vào cuối tuần. Bạn có thể xem xét điều chỉnh ngưỡng nhạy cảm vào các khung giờ cao điểm để giảm báo động giả thêm 0.5%.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
