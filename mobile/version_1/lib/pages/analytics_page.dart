import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1120),
      appBar: AppBar(
        title: const Text('PHÂN TÍCH', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SpaceGrotesk')),
        backgroundColor: const Color(0xFF0A1120),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                   Expanded(child: _buildKPICard('Độ trễ TB', '12ms', '-2ms', Colors.red, true)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildKPICard('FPS TB', '60', '+5', Colors.green, false)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildKPICard('Độ chính xác AI', '98.5%', '+0.2%', Colors.green, false),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Hiệu suất Hệ thống', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildLargeChartCard('Tốc độ khung hình (FPS)', '60 FPS', '24 giờ qua', '+2%', Colors.green, _buildFpsLineChart()),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildLargeChartCard('Độ trễ xử lý (ms)', '12 ms', 'Xử lý tải', '-5.4%', Colors.red, _buildLatencyBarChart()),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String label, String value, String change, Color changeColor, bool isNegativeGood) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(change, style: TextStyle(color: changeColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeChartCard(String title, String value, String subtitle, String change, Color changeColor, Widget chartWidget) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                  Text(change, style: TextStyle(color: changeColor, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 120,
            width: double.infinity,
            child: chartWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildFpsLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold);
                switch (value.toInt()) {
                  case 0: return const Text('00:00', style: style);
                  case 3: return const Text('08:00', style: style);
                  case 6: return const Text('16:00', style: style);
                  case 9: return const Text('23:59', style: style);
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
          LineChartBarData(
            spots: const [
              FlSpot(0, 58),
              FlSpot(2, 59),
              FlSpot(4, 61),
              FlSpot(6, 60),
              FlSpot(8, 59),
              FlSpot(9, 60),
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
        ],
        minX: 0,
        maxX: 9,
        minY: 55,
        maxY: 65,
      ),
    );
  }

  Widget _buildLatencyBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold);
                String text;
                switch (value.toInt()) {
                  case 0: text = '00h'; break;
                  case 1: text = '06h'; break;
                  case 2: text = '12h'; break;
                  case 3: text = '18h'; break;
                  case 4: text = 'Nay'; break;
                  default: text = ''; break;
                }
                return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 16, color: const Color(0xFF3B82F6).withOpacity(0.4), width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 13, color: const Color(0xFF3B82F6).withOpacity(0.4), width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 19, color: const Color(0xFF3B82F6).withOpacity(0.4), width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 8,  color: const Color(0xFF3B82F6).withOpacity(0.4), width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 12, color: const Color(0xFF3B82F6),               width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))]),
        ],
      ),
    );
  }
}