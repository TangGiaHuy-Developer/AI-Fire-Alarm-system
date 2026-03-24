import 'dart:convert';
import 'dart:async';
import 'package:flutter_frontend/models/camera_status.dart';
import 'package:flutter_frontend/models/event_log.dart';
import 'package:flutter_frontend/resources/video_resource.dart';
import 'package:http/http.dart' as http;

// ================= CONFIG =================
// Lưu ý: Nếu chạy trên máy ảo Android, dùng 10.0.2.2 thay vì localhost/127.0.0.1
// Nếu chạy trên thiết bị thật, hãy dùng IP LAN của máy tính (VD: 192.168.1.x)
const String BASE_URL = "http://192.168.1.10:5000"; 

class ApiService {
  
  static String getStreamUrl(String camId) {
    return "$BASE_URL/stream/$camId";
  }

  static Future<CameraStatus> getDetectionStatus(String camId) async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/detection/$camId"));
      
      if (response.statusCode == 200) {
        return CameraStatus.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Lỗi tải trạng thái camera");
      }
    } catch (e) {
      print("Error fetching detection: $e");
      return CameraStatus.disconnected();
    }
  }

  static Future<List<EventLog>> getLatestEvents() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/api/events/latest"));
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => EventLog.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  static Future<bool> confirmFalseAlarm() async {
    return _postConfirm("$BASE_URL/api/events/confirm-false");
  }

  static Future<bool> confirmTrueAlarm() async {
    return _postConfirm("$BASE_URL/api/events/confirm-true");
  }

  static Future<bool> _postConfirm(String url) async {
    try {
      final response = await http.post(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      print("Error confirming event: $e");
      return false;
    }
  }

  static Future<VideoResponse> getRecordedVideos({
    String? camId,
    String? alertLevel,
    int limit = 50,
  }) async {
    try {
      String query = "?limit=$limit";
      if (camId != null) query += "&cam_id=$camId";
      if (alertLevel != null) query += "&alert_level=$alertLevel";

      final response = await http.get(Uri.parse("$BASE_URL/api/videos$query"));

      if (response.statusCode == 200) {
        return VideoResponse.fromJson(jsonDecode(response.body));
      }
      return VideoResponse(total: 0, videos: []);
    } catch (e) {
      print("Error fetching videos: $e");
      return VideoResponse(total: 0, videos: []);
    }
  }
}