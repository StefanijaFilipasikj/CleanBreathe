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
}
