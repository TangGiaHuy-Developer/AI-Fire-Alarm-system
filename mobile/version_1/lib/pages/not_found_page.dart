import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text('404 Page Not Found', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('Trở về Trang chủ', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
