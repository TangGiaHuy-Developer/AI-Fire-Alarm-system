import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final _firebaseMessage = FirebaseMessaging.instance;
  Timer? _tokenRefreshTimer;

  // Thay bằng IP máy chạy Python Server của bạn
  // Nếu dùng Android Emulator thì dùng 10.0.2.2, máy thật thì dùng IP LAN (vd: 192.168.1.x)
  static const String _backendUrl = 'https://bao-chay-api-tagname.onrender.com/api/register-token';

  Future<void> initFCM() async {
    NotificationSettings settings = await _firebaseMessage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true, // Bật cái này lên cho cảnh báo quan trọng
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    final fcmToken = await _firebaseMessage.getToken();
    if (fcmToken != null) {
      print("Fcm token: $fcmToken");
      await _sendTokenToServer(fcmToken); 
    }

     _tokenRefreshTimer = Timer.periodic(
        Duration(minutes: 5), 
        (_) => _refreshTokenToServer()
      );
      

    _firebaseMessage.onTokenRefresh.listen((newToken) async {
      print("FCM Token Refreshed: $newToken");
      await _sendTokenToServer(newToken); 
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    
  }


  Future<void> _refreshTokenToServer() async {
    try {
      final currentToken = await _firebaseMessage.getToken();
      if (currentToken != null) {
        print("🔄 Refreshing token to server...");
        await _sendTokenToServer(currentToken);
      }
    } catch (e) {
      print("Token refresh error: $e");
    }
  }
  
  void dispose() {
    _tokenRefreshTimer?.cancel();
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );
      
      if (response.statusCode == 200) {
        print("Token registered with server successfully");
      } else {
        print("Failed to register token: ${response.body}");
      }
    } catch (e) {
      print("Error sending token to server: $e");
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("📱 Foreground Message Received!");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
  }

  void _handleNotificationTap(RemoteMessage message) {
    print("🔔 Notification tapped!");
  }
  
}