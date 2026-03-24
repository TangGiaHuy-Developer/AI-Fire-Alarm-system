// File: lib/components/sidebar.dart
import 'package:flutter/material.dart';

class SidebarNav extends StatelessWidget {
  final int selectedIndex;
  final Function(String) onNavigate;
  final bool isVisible;
  final VoidCallback onToggleSidebar;

  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.onNavigate,
    required this.isVisible,
    required this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header của sidebar
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/logovhu.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'FIREGUARD',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white54,
                  onPressed: onToggleSidebar,
                  tooltip: 'Đóng',
                ),
              ],
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  index: 0,
                  route: '/dashboard',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics,
                  label: 'Analytics',
                  index: 1,
                  route: '/analytics',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  index: 2,
                  route: '/settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = selectedIndex == index;
    
    return InkWell(
      onTap: () => onNavigate(route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE53935).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE53935).withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE53935) : Colors.white54,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFE53935) : Colors.white70,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}