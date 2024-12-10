import 'package:latlong2/latlong.dart';

class City {
  final String name;
  final LatLng location;
  final String qualitySummary;
  final String country;

  City(this.name, this.location, this.country, this.qualitySummary);
}