import 'package:clean_breathe/features/common/static_info/colors_by_value.dart';
import 'package:clean_breathe/features/common/static_info/texts_by_average.dart';
import 'package:clean_breathe/features/common/utils/change_value_to_unit.dart';
import 'package:clean_breathe/features/common/utils/values.dart';
import 'package:clean_breathe/features/map/model/sensor_details.dart';
import 'package:clean_breathe/features/map/model/sensor_details_measurements.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:home_widget/home_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/sensor.dart';
import '../repository/sensor_repository.dart';

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
  bool _isSensorSelected = false;
  SensorDetailsMeasurements? _selectedSensor = null;

  MapViewModel(this._sensorRepository);

  LatLng? get currentLocation => _currentLocation;
  String? get currentCity => _currentCity;
  String? get currentCountry => _currentCountry;
  bool get isLoading => _isLoading;
  bool get loadingSensors => _loadingSensors;
  String get selectedPollutant => _selectedPollutant;
  String get selectedDate => _selectedDate;
  List<Sensor> get sensors => _sensors;
  bool get isSensorSelected => _isSensorSelected;
  SensorDetailsMeasurements? get selectedSensor => _selectedSensor;

  void init() {
    _loadSavedCity();
  }

  Future<void> selectSensor(String sensorId) async {
    Sensor sensorValue = _sensors.where((sensor) => sensor.sensorId == sensorId).single;
    String sensorName = (await _sensorRepository.fetchSensorDetails(_currentCity!, sensorId)).description;

    _selectedSensor = new SensorDetailsMeasurements(
        sensorName,
        sensorValue.value.toInt().toString(),
        changeValueToUnit(sensorValue.type),
        "${sensorValue.timeStamp.hour}:${sensorValue.timeStamp.minute}",
        "${sensorValue.timeStamp.day}.${sensorValue.timeStamp.month}.${sensorValue.timeStamp.year}",
    );
    _isSensorSelected = true;

    notifyListeners();
  }

  void unselectSensor() {
    _selectedSensor = null;
    _isSensorSelected = false;
    notifyListeners();
  }

  Future<void> _loadSavedCity() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedCity = prefs.getString('currentCity');
    if (savedCity != null) {
      _currentCity = savedCity;
      _currentCountry = prefs.getString('currentCountry');
      String? lat = prefs.getString('currentLatitude');
      String? lon = prefs.getString('currentLongitude');
      if (lat != null && lon != null) {
        _currentLocation = LatLng(double.parse(lat), double.parse(lon));
      }
      _isLoading = false; // Ensure loading is complete
      notifyListeners();

      await _fetchSensorsForSavedCity();
    } else {
      _determinePosition();
    }
  }

  Future<void> _fetchSensorsForSavedCity() async {
    if (_currentCity != null) {
      var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
      await _fetchSensors(_cityNameTrim, _selectedPollutant, _selectedDate);
    }
  }

  Future<void> _saveCity(String cityName, String country, LatLng location) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentCity', cityName);
    await prefs.setString('currentCountry', country);
    await prefs.setString('currentLatitude', location.latitude.toString());
    await prefs.setString('currentLongitude', location.longitude.toString());
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
      debugPrint("Error determining position: $e");
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
        Values.city = _currentCity!;
        var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
        await _fetchSensors(_cityNameTrim, _selectedPollutant, _selectedDate);

        // Save city to SharedPreferences
        await _saveCity(_currentCity!, _currentCountry!, _currentLocation!);
      }
    } catch (e) {
      debugPrint("Error fetching city name: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchSensors(String cityName, String pollutant, String date) async {
    _loadingSensors = true;
    notifyListeners();

    try {
      var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
      _sensors = await _sensorRepository.fetchSensors(_cityNameTrim, pollutant, date);
    } catch (e) {
      debugPrint("Error fetching sensors: $e");
    } finally {
      _loadingSensors = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void changePollutant(String pollutant) {
    _selectedPollutant = pollutant;
    if (_currentCity != null) {
      var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
      _fetchSensors(_cityNameTrim, _selectedPollutant, _selectedDate);
    }
    Values.valueType = pollutant;
    notifyListeners();
  }

  void changeDate(String date) {
    _selectedDate = date;
    if (_currentCity != null) {
      var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
      _fetchSensors(_cityNameTrim, _selectedPollutant, _selectedDate);
    }
    notifyListeners();
  }

  double cityAverage() {
    HomeWidget.saveWidgetData<String>('currentCity', _currentCity);

    if (_sensors.length == 0) return 0.0;
    double avg = _sensors.map((s) => s.value).reduce((a, b) => a + b) / _sensors.length;
    Values.average = avg;

    HomeWidget.saveWidgetData<String>('pollutionText', TextByAvgValue.get().split('.').first.trim());

    final color = ColorByValue.get(avg);
    final colorHex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    HomeWidget.saveWidgetData<String>('widgetBackgroundColor', colorHex);
    HomeWidget.saveWidgetData<String>('averageAQI', avg.toStringAsFixed(0));
    HomeWidget.updateWidget(name: 'HomeScreenWidgetProvider', androidName: 'com.example.clean_breathe.HomeScreenWidgetProvider');

    return avg;
  }

  String pollutantMeasure() {
    return changeValueToUnit(_selectedPollutant);
  }

  void updateCity(String cityName, LatLng location, String country) {
    _currentCity = cityName;
    _currentLocation = location;
    _currentCountry = country;
    var _cityNameTrim = _currentCity!.replaceAll(RegExp(r"\s+"), "");
    _fetchSensors(_cityNameTrim, _selectedPollutant, _selectedDate);


    _saveCity(_currentCity!, _currentCountry!, _currentLocation!);

    Values.city = cityName;
    notifyListeners();
  }

  Future<String> averageForCity(String cityName) async {
    var _cityNameTrim = cityName.replaceAll(RegExp(r"\s+"), "");
    var _citySensors = await _sensorRepository.fetchSensors(_cityNameTrim, _selectedPollutant, selectedDate.toString());

    if (_citySensors.isEmpty) return "0";
    var _cityAvg = _citySensors.map((s) => s.value).reduce((a, b) => a + b) / _citySensors.length;

    Values.average = _cityAvg;
    return _cityAvg.toString();
  }
}
