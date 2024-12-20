class Device{
  int sensorId;
  String deviceId;
  double latitude;
  double longitude;
  String comment;
  String description;
  String type;
  String status;

  Device({
    required this.sensorId,
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.comment,
    required this.description,
    required this.type,
    required this.status
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      sensorId: json['sensorId'],
      deviceId: json['deviceId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      comment: json['comment'],
      description: json['description'],
      type: json['type'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'deviceId': deviceId,
      'latitude': latitude,
      'longitude': longitude,
      'comment': comment,
      'description': description,
      'type': type,
      'status': status
    };
  }
}