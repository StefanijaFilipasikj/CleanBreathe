import 'package:latlong2/latlong.dart';

class City {
  final String name;
  final LatLng location;
  final String country;

  City(this.name, this.location, this.country);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City &&
        other.name == name &&
        other.country == country &&
        other.location == location;
  }

  @override
  int get hashCode => name.hashCode ^ country.hashCode ^ location.hashCode;
}