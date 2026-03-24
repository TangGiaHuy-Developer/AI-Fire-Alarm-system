// File: lib/components/main_layout.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'header.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool _isSidebarVisible = false;
  late AnimationController _animationController;
  late Animation<double> _sidebarAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _sidebarAnimation = Tween<double>(
      begin: -240, 
      end: 0, 
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _contentAnimation = Tween<double>(
      begin: 0, 
      end: 240, 
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
      
      if (_isSidebarVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleNavigation(String route) {
    if (_isSidebarVisible) {
      _animationController.reverse().then((_) {
        setState(() {
          _isSidebarVisible = false;
        });
        Navigator.of(context).pushReplacementNamed(route);
      });
    } else {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    
    switch (currentRoute) {
      case '/':
      case '/dashboard':
        return 0;
      case '/analytics':
        return 1;
      case '/settings':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_contentAnimation.value, 0),
                child: Container(
                  width: screenWidth,
                  child: Column(
                    children: [
                      // Header cố định
                      Header(
                        title: _getTitleFromIndex(selectedIndex),
                        onMenuPressed: _toggleSidebar,
                      ),
                      
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: screenWidth,
                            maxWidth: screenWidth,
                          ),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_sidebarAnimation.value, 0),
                child: SizedBox(
                  width: 240,
                  child: SidebarNav(
                    selectedIndex: selectedIndex,
                    onNavigate: _handleNavigation,
                    isVisible: _isSidebarVisible,
                    onToggleSidebar: _toggleSidebar,
                  ),
                ),
              );
            },
          ),
          
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              if (_animationController.value == 0) {
                return const SizedBox.shrink();
              }
              
              return Positioned(
                left: 240, 
                top: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _toggleSidebar,
                  behavior: HitTestBehavior.opaque,
                  // child: Container(
                  //   color: Colors.black.withOpacity(
                  //     _animationController.value * 0.3,
                  //   ),
                  // ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getTitleFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Analytics';
      case 2:
        return 'Settings';
      default:
        return 'FireGuard';
    }
  }
}