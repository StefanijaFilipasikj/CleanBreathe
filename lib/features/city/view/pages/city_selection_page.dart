import 'package:clean_breathe/features/city/model/city.dart';
import 'package:clean_breathe/features/city/view-model/city_view_model.dart';
import 'package:clean_breathe/features/city/view/pages/city_search_page.dart';
import 'package:clean_breathe/features/map/view-model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/city_tile.dart';
class CitySelectionPage extends StatelessWidget {
  const CitySelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityViewModel = Provider.of<CityViewModel>(context);
    final mapViewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select a City')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (mapViewModel.currentCity != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'Currently Selected City',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    CityTile(
                      city: City(
                        mapViewModel.currentCity!,
                        mapViewModel.currentLocation!,
                        mapViewModel.currentCountry!,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      isFavorite: cityViewModel.favorites.any(
                            (city) => city.name == mapViewModel.currentCity,
                      ),
                      onFavoriteToggle: () {
                        final currentCity = City(
                          mapViewModel.currentCity!,
                          mapViewModel.currentLocation!,
                          mapViewModel.currentCountry!,
                        );
                        cityViewModel.addToFavorites(currentCity);
                      },
                      cityAverage: mapViewModel.cityAverage(),
                      pollutantMeasure: mapViewModel.pollutantMeasure(),
                    ),

                  ],
                ),
              ),
            if (cityViewModel.favorites.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'Favorites',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ...cityViewModel.favorites.map((city) => Column(
                      children: [
                        CityTile(
                          city: city,
                          onTap: () {
                            mapViewModel.updateCity(
                                city.name, city.location, city.country);
                            Navigator.pop(context);
                          },
                          isFavorite: true,
                          onFavoriteToggle: () {
                            cityViewModel.addToFavorites(city);
                          },
                          cityAverage: mapViewModel.cityAverage(),
                          pollutantMeasure: mapViewModel.pollutantMeasure(),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            if (cityViewModel.history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'History',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ...cityViewModel.history.map((city) => Column(
                      children: [
                        CityTile(
                          city: city,
                          onTap: () {
                            mapViewModel.updateCity(
                                city.name, city.location, city.country);
                            Navigator.pop(context);
                          },
                          isFavorite:
                          cityViewModel.favorites.contains(city),
                          onFavoriteToggle: () {
                            cityViewModel.addToFavorites(city);
                          },
                          cityAverage: 0,
                          pollutantMeasure: mapViewModel.pollutantMeasure(),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchCityPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Search City',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
