import 'package:flutter/material.dart';
import 'package:flutter_frontend/firebase_options.dart';
import 'package:flutter_frontend/services/notification_service.dart';

import 'pages/dashboard_page.dart';
import 'pages/analytics_page.dart';
import 'pages/settings_page.dart';
import 'pages/not_found_page.dart';
import 'components/main_layout.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ đăng ký background handler NGAY SAU init Firebase
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // ✅ RUN APP SỚM
  runApp(const FireSmokeApp());

  // ❗ FCM foreground init → để SAU runApp
  _initFCMAfterAppStart();
}

Future<void> _initFCMAfterAppStart() async {
  final notification = NotificationService();
  await notification.initFCM();
}


class FireSmokeApp extends StatelessWidget {
  const FireSmokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Smoke Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE53935),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        fontFamily: 'RobotoMono',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Tất cả routes đều dùng MainLayout
        Widget page;
        
        switch (settings.name) {
          case '/':
          case '/dashboard':
            page = const DashboardPage();
            break;
          case '/analytics':
            page = const AnalyticsPage();
            break;
          case '/settings':
            page = const SettingsPage();
            break;
          case '/not-found':
            page = const NotFoundPage();
            break;
          default:
            page = const NotFoundPage();
        }

        return MaterialPageRoute(
          builder: (_) => MainLayout(child: page),
          settings: settings,
        );
      },
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Message: ${message.notification?.title}");
}