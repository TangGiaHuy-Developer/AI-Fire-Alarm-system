class CameraStatus {
  final String alertLevel;
  final int fps;
  final List<dynamic> bboxes; 

  CameraStatus({required this.alertLevel, required this.fps, required this.bboxes});

  factory CameraStatus.fromJson(Map<String, dynamic> json) {
    return CameraStatus(
      alertLevel: json['alert_level'] ?? 'unknown',
      fps: json['fps'] ?? 0,
      bboxes: json['bboxes'] ?? [],
    );
  }

  factory CameraStatus.disconnected() {
    return CameraStatus(alertLevel: 'disconnected', fps: 0, bboxes: []);
  }
}