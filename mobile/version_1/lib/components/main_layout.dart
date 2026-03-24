import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  int _getSelectedIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    
    switch (currentRoute) {
      case '/analytics':
        return 0;
      case '/':
      case '/dashboard':
        return 1;
      case '/incidents':
        return 2;
      case '/reports':
        return 3;
      case '/settings':
        return 4;
      default:
        return 1;
    }
  }

  void _handleNavigation(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
        Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // background-dark
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onNavigate: (route) => _handleNavigation(context, route),
      ),
    );
  }
}