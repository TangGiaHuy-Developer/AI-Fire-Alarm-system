// File: lib/components/header.dart
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const Header({
    super.key,
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.format_align_left_rounded,
                size: 28,
              ),
              color: const Color(0xFFE53935),
              onPressed: onMenuPressed,
              tooltip: 'Menu',
            ),
          ),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE53935),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}