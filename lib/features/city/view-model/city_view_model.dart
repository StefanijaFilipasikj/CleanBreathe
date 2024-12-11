import 'package:clean_breathe/features/city/model/city.dart';
import 'package:clean_breathe/features/city/repository/city_repository.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

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

  void addToFavorites(City city) {

    bool cityExists = _favorites.any((favCity) =>
    favCity.name == city.name &&
        favCity.country == city.country &&
        favCity.location.latitude == city.location.latitude &&
        favCity.location.longitude == city.location.longitude);

    if (!cityExists) {
      _favorites.add(city);
      notifyListeners();
    } else {
      removeFromFavorites(city);
    }
  }


  void removeFromFavorites(City city) {
    if (_favorites.contains(city)) {
      _favorites.remove(city);
      notifyListeners();
    }
  }

  void addToHistory(City city) {
    if (!_history.contains(city)) {
      _history.add(city);
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
