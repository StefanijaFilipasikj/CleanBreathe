class Sensor {
  final String sensorId;
  final String type;
  final double value;
  final double latitude;
  final double longitude;
  final DateTime timeStamp;

  Sensor({
    required this.sensorId,
    required this.type,
    required this.value,
    required this.latitude,
    required this.longitude,
    required this.timeStamp
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    var position = json['position'].split(',');
    return Sensor(
      sensorId: json['sensorId'],
      type: json['type'],
      timeStamp: DateTime.parse(json['stamp']),
      value: double.parse(json['value']),
      latitude: double.parse(position[0]),
      longitude: double.parse(position[1]),
    );
  }
}
