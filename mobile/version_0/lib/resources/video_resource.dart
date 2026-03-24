import 'package:flutter_frontend/models/video_record.dart';

class VideoResponse {
  final int total;
  final List<VideoRecord> videos;

  VideoResponse({required this.total, required this.videos});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    var list = json['videos'] as List;
    List<VideoRecord> videosList = list.map((i) => VideoRecord.fromJson(i)).toList();
    return VideoResponse(total: json['total'] ?? 0, videos: videosList);
  }
}