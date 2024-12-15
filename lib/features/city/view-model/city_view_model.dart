import 'dart:convert';
import 'package:clean_breathe/features/city/model/city.dart';
import 'package:clean_breathe/features/city/repository/city_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityViewModel extends ChangeNotifier {
  final CityRepository _cityRepository = CityRepository();

  List<City> _favorites = [];
  List<City> _history = [];
  List<City> _searchResults = [];
  bool _isLoading = false;

  List<City> get favorites => _favorites;
  List<City> get history => _history;
  List<City> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  CityViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    String? favoritesData = prefs.getString('favorites');
    if (favoritesData != null) {
      List<dynamic> decodedFavorites = json.decode(favoritesData);
      _favorites = decodedFavorites
          .map((e) => City.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    String? historyData = prefs.getString('history');
    if (historyData != null) {
      List<dynamic> decodedHistory = json.decode(historyData);
      _history = decodedHistory
          .map((e) => City.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    String favoritesJson = json.encode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);

    String historyJson = json.encode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('history', historyJson);
  }

  void addToFavorites(City city) {
    bool cityExists = _favorites.any((favCity) =>
    favCity.name == city.name &&
        favCity.country == city.country &&
        favCity.location.latitude == city.location.latitude &&
        favCity.location.longitude == city.location.longitude);

    if (!cityExists) {
      if(_favorites.length >= 5)
        return;
      _favorites.add(city);
      _saveData();
      notifyListeners();
    } else {
      removeFromFavorites(city);
    }
  }

  void removeFromFavorites(City city) {
    if (_favorites.contains(city)) {
      _favorites.remove(city);
      _saveData();
      notifyListeners();
    }
  }

  void addToHistory(City city) {
    if (!_history.contains(city)) {
      if (_history.length >= 5) {
        _history.removeAt(0);
      }
      _history.add(city);
      _saveData();
      notifyListeners();
    }
  }


  Future<void> searchCities(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<City> cities = await _cityRepository.fetchCities(query);

      _searchResults = cities
          .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

    } catch (e) {
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
