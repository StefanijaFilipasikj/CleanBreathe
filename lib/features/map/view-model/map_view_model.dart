import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../model/sensor.dart';
import '../repository/sensor_repository.dart';

class MapViewModel extends ChangeNotifier {
  final SensorRepository _sensorRepository;
  LatLng? _currentLocation;
  String? _currentCity;
  bool _isLoading = true;
  bool _loadingSensors = false;
  List<Sensor> _sensors = [];
  String _selectedPollutant = "pm10"; // Default pollutant

  MapViewModel(this._sensorRepository);

  LatLng? get currentLocation => _currentLocation;
  String? get currentCity => _currentCity;
  bool get isLoading => _isLoading;
  bool get loadingSensors => _loadingSensors;
  String get selectedPollutant => _selectedPollutant;

  List<Marker> get sensorMarkers => [
    ..._sensors.map((sensor) =>
      Marker(
        point: LatLng(sensor.latitude, sensor.longitude),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: getColorForValue(sensor.value),
          size: 40.0,
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
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        _currentCity = placemarks[0].locality;
        notifyListeners();
        await _fetchSensors(_currentCity!);
      }
    } catch (e) {
      debugPrint("Error fetching city name: $e");
    }
  }

  Future<void> _fetchSensors(String cityName) async {
    _loadingSensors = true;
    notifyListeners();

    try {
      _sensors = (await _sensorRepository.fetchSensors(cityName))
        .where((sensor) => sensor.type == _selectedPollutant)
        .toList();
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
      _fetchSensors(_currentCity!);
    }
    notifyListeners();
  }

  Color getColorForValue(double value) {
    //TODO make this dynamic, each pollutant has a different color scale
    if(value < 20.0){
      return Color.fromRGBO(37, 143, 48, 1); //dark green
    }else if(value < 50.0){
      return Color.fromRGBO(79, 191, 73, 1); //lighter green
    }else if(value < 80.0){
      return Color.fromRGBO(245, 202, 61, 1); //yellow-orange
    }else if(value < 150.0){
      return Color.fromRGBO(214, 66, 81, 1); //red-pink
    }else{
      return Color.fromRGBO(131, 29, 40, 1.0); //dark-red
    }
  }
}
