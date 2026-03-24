import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(String) onNavigate;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // background-dark
        border: Border(
          top: BorderSide(
            color: const Color(0xFF3B82F6).withOpacity(0.2), // primary/20
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.analytics,
                label: 'Phân tích',
                route: '/analytics',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.shield_outlined,
                label: 'Giám sát',
                route: '/dashboard',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_none,
                label: 'Sự cố',
                route: '/incidents',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.bar_chart,
                label: 'Báo cáo',
                route: '/reports',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.settings,
                label: 'Cài đặt',
                route: '/settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade500;

    return InkWell(
      onTap: () => onNavigate(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
