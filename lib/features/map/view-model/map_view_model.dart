import 'package:clean_breathe/features/common/utils/get_color_for_value.dart';
import 'package:clean_breathe/features/common/utils/get_text_for_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../model/sensor.dart';
import '../repository/sensor_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_decoration/icon_decoration.dart';


class MapViewModel extends ChangeNotifier {
  final SensorRepository _sensorRepository;
  LatLng? _currentLocation;
  String? _currentCity;
  String? _currentCountry;
  bool _isLoading = true;
  bool _loadingSensors = false;
  List<Sensor> _sensors = [];
  String _selectedPollutant = "pm10"; // Default pollutant
  String _selectedDate = DateTime.now().toString(); // Default date

  MapViewModel(this._sensorRepository);

  LatLng? get currentLocation => _currentLocation;

  String? get currentCity => _currentCity;

  String? get currentCountry => _currentCountry;

  bool get isLoading => _isLoading;

  bool get loadingSensors => _loadingSensors;

  String get selectedPollutant => _selectedPollutant;

  String get selectedDate => _selectedDate;

  List<Sensor> get sensors => _sensors;

  List<Marker> get sensorMarkers =>
      [
        ..._sensors.map((sensor) =>
            Marker(
              point: LatLng(sensor.latitude, sensor.longitude),
              builder: (ctx) =>
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      DecoratedIcon(
                        icon: Icon(
                          FontAwesomeIcons.locationPin, size: 50.0,
                          color: GetColorForValue.get(sensor.value),
                          shadows: [
                            Shadow(color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 0),),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            sensor.value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            )
        )
      ];

  void init() {
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
      notifyListeners();

      _getCityName(position.latitude, position.longitude);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude, localeIdentifier: "en");
      if (placemarks.isNotEmpty) {
        _currentCity = placemarks[0].locality;
        _currentCountry = placemarks.first.country;
        notifyListeners();
        await _fetchSensors(_currentCity!, _selectedPollutant, _selectedDate);
      }
    } catch (e) {
      debugPrint("Error fetching city name: $e");
    }
  }

  Future<void> _fetchSensors(String cityName, String pollutant,
      String date) async {
    _loadingSensors = true;
    notifyListeners();

    try {
      _sensors =
      await _sensorRepository.fetchSensors(cityName, pollutant, date);
    } catch (e) {
      debugPrint("Error fetching sensors: $e");
    } finally {
      _loadingSensors = false;
      notifyListeners();
    }
  }

  void changePollutant(String pollutant) {
    _selectedPollutant = pollutant;
    if (_currentCity != null) {
      _fetchSensors(_currentCity!, _selectedPollutant, _selectedDate);
    }
    GetColorForValue.valueType = pollutant;
    GetTextForValue.valueType = pollutant;
    notifyListeners();
  }

  void changeDate(String date) {
    _selectedDate = date;
    if (_currentCity != null) {
      _fetchSensors(_currentCity!, _selectedPollutant, _selectedDate);
    }
    notifyListeners();
  }

  double cityAverage() {
    if (_sensors.length == 0) return 0.0;
    return _sensors.map((s) => s.value).reduce((a, b) => a + b) /
        _sensors.length;
  }

  String pollutantMeasure() {
    return switch (_selectedPollutant) {
      "noise" => "dBA",
      "temperature" => "°C",
      "humidity" => "%",
      "pressure" => "hPa",
      _ => "μg/m³",
    };
  }

  void updateCity(String cityName, LatLng location, String country) {
    _currentCity = cityName;
    _currentLocation = location;
    _currentCountry = country;
    _fetchSensors(_currentCity!, _selectedPollutant, _selectedDate);
    notifyListeners();
  }

  Future<String> averageForCity(String cityName) async {
    var _citySensors = await _sensorRepository.fetchSensors(cityName, _selectedPollutant, selectedDate.toString());

    if (_citySensors.isEmpty) return "0";
    var _cityAvg = _citySensors.map((s) => s.value).reduce((a, b) => a + b) /
        _citySensors.length;

    return _cityAvg.toString();
  }

}


