import 'package:latlong2/latlong.dart';

class SensorDetails {
  final String sensorId;
  final LatLng position;
  final String type;
  final String description;
  final String comments;
  final String status;


  SensorDetails(this.sensorId, this.position, this.type, this.description,
      this.comments, this.status);
}