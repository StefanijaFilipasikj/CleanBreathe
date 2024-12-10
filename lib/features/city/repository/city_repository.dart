import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:clean_breathe/features/city/model/city.dart';

class CityRepository {
  Future<List<City>> fetchCities(String query) async {
    List<City> cities = [
      City('Skopje', LatLng(41.9981, 21.4254), 'Macedonia', ''),
      City('Bitola', LatLng(41.0328, 21.3401), 'Macedonia', ''),
      City('Ohrid', LatLng(41.1172, 20.8016), 'Macedonia', ''),
      City('Tetovo', LatLng(42.0067, 20.9714), 'Macedonia', ''),
      City('Veles', LatLng(41.7156, 21.7750), 'Macedonia', ''),
      City('Kumanovo', LatLng(42.1322, 21.7144), 'Macedonia', ''),
      City('Resen', LatLng(41.0903, 21.0133), 'Macedonia', ''),
      City('Magdeburg', LatLng(52.1203, 11.6276), 'Germany', ''),
    ];

    return cities.toList();
  }
}
