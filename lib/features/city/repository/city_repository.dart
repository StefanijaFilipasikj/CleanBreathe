import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:clean_breathe/features/city/model/city.dart';

class CityRepository {
    List<City> cities = [
      City('Skopje', LatLng(41.9981, 21.4254), 'North Macedonia'),
      City('Bitola', LatLng(41.0328, 21.3401), 'North Macedonia'),
      City('Ohrid', LatLng(41.1172, 20.8016), 'North Macedonia'),
      City('Tetovo', LatLng(42.0067, 20.9714), 'North Macedonia'),
      City('Kumanovo', LatLng(42.1322, 21.7144), 'North Macedonia'),
      City('Resen', LatLng(41.0903, 21.0133), 'North Macedonia'),
      City('Novo Selo', LatLng(41.4144, 22.8811), 'North Macedonia'),
      City('Struga', LatLng(41.1780, 20.6769), 'North Macedonia'),
      City('Star Dojran', LatLng(41.1865, 22.7203), 'North Macedonia'),
      City('Shtip', LatLng(41.7458, 22.1958), 'North Macedonia'),
      City('Gostivar', LatLng(41.7970, 20.9082), 'North Macedonia'),
      City('Strumica', LatLng(41.4378, 22.6431), 'North Macedonia'),
      City('Bogdanci', LatLng(41.2033, 22.5753), 'North Macedonia'),
      City('Kichevo', LatLng(41.5123, 20.9586), 'North Macedonia'),


      City('Tirana', LatLng(41.3275, 19.8189), 'Albania'),

      City('Sofia', LatLng(42.6977, 23.3219), 'Bulgaria'),
      City('Yambol', LatLng(42.4848, 26.5037), 'Bulgaria'),

      City('Zagreb', LatLng(45.8150, 15.9819), 'Croatia'),

      City('Nicosia', LatLng(35.1856, 33.3823), 'Cyprus'),

      City('Copenhagen', LatLng(55.6761, 12.5683), 'Denmark'),

      City('Berlin', LatLng(52.5200, 13.4050), 'Germany'),
      City('Magdeburg', LatLng(52.1203, 11.6276), 'Germany'),

      City('Syros', LatLng(37.4458, 24.9439), 'Greece'),
      City('Thessaloniki', LatLng(40.6401, 22.9444), 'Greece'),

      City('Cork', LatLng(51.8985, -8.4756), 'Ireland'),

      City('Chisinau', LatLng(47.0105, 28.8638), 'Romania'),

      City('Nis', LatLng(43.3209, 21.8958), 'Serbia'),

      City('Lausanne', LatLng(46.5197, 6.6323), 'Switzerland'),
      City('Zurich', LatLng(47.3769, 8.5417), 'Switzerland'),
      City('Zuchwil', LatLng(47.2012, 7.5583), 'Switzerland'),
      City('Bern', LatLng(46.9481, 7.4474), 'Switzerland'),
      City('Luzern', LatLng(47.0502, 8.3093), 'Switzerland'),
      City('Grenchen', LatLng(47.1920, 7.3959), 'Switzerland'),

      City('Grand Rapids', LatLng(42.9634, -85.6681), 'USA'),
      City('Portland', LatLng(45.5152, -122.6784), 'USA')
    ];

  Future<List<City>> fetchCities(String query) async {
    return cities.toList();
  }

  City getCity(String cityName) {
    return cities.firstWhere((c) => c.name == cityName);
  }
}
