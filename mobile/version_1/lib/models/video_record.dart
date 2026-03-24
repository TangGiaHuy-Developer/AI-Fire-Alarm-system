import 'package:flutter_frontend/services/api_service.dart';

class VideoRecord {
  final int id;
  final String camId;
  final String alertLevel;
  final String label;
  final String fileName;
  final String filePath;
  final String eventTime; 

  VideoRecord({
    required this.id,
    required this.camId,
    required this.alertLevel,
    required this.label,
    required this.fileName,
    required this.filePath,
    required this.eventTime,
  });

  factory VideoRecord.fromJson(Map<String, dynamic> json) {
    return VideoRecord(
      id: json['id'],
      camId: json['cam_id'] ?? '',
      alertLevel: json['alert_level'] ?? '',
      label: json['label'] ?? '',
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      eventTime: json['event_time'] ?? '',
    );
  }
  
  String get downloadUrl => "$BASE_URL/recordings/$camId/${eventTime.split(' ')[0]}/$fileName";
}