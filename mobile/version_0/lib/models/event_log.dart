class EventLog {
  final String id;
  final String type;
  final String message;
  final String camera;
  final String timestamp;
  final double? confidence;
  final String? confirmed;

  EventLog({
    required this.id,
    required this.type,
    required this.message,
    required this.camera,
    required this.timestamp,
    this.confidence,
    this.confirmed,
  });

  factory EventLog.fromJson(Map<String, dynamic> json) {
    return EventLog(
      id: json['id'] ?? '',
      type: json['type'] ?? 'INFO',
      message: json['message'] ?? '',
      camera: json['camera'] ?? '',
      timestamp: json['timestamp'] ?? '',
      confidence: json['confidence'] != null ? (json['confidence'] as num).toDouble() : null,
      confirmed: json['confirmed'],
    );
  }
}