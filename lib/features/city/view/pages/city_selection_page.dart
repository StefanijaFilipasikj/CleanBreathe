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
    final viewModel = Provider.of<CityViewModel>(context);
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Select a City')),
      body: Column(
        children: [
          if (viewModel.selectedCity != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: Text(
                        'Currently Selected',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  CityTile(
                    city: viewModel.selectedCity,
                    onTap: () {
                      viewModel.selectCity(viewModel.selectedCity);
                      mapViewModel.updateCity(
                        viewModel.selectedCity.name,
                        viewModel.selectedCity.location,
                      );
                      Navigator.pop(context);
                    },
                    isFavorite: viewModel.favorites.contains(viewModel.selectedCity),
                    onFavoriteToggle: () => viewModel.addToFavorites(viewModel.selectedCity),
                    cityAverage: mapViewModel.cityAverage(),
                    pollutantMeasure: mapViewModel.pollutantMeasure(),
                    airQualitySummary: '',
                  ),
                ],
              ),
            ),

          if (viewModel.favorites.isNotEmpty)
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
                  ...viewModel.favorites.map((city) => Column(
                    children: [
                      CityTile(
                        city: city,
                        onTap: () {
                          viewModel.selectCity(city);
                          mapViewModel.updateCity(city.name, city.location);
                          Navigator.pop(context);
                        },
                        isFavorite: true,
                        onFavoriteToggle: () => viewModel.addToFavorites(city),
                        cityAverage: mapViewModel.cityAverage(),
                        pollutantMeasure: mapViewModel.pollutantMeasure(),
                        airQualitySummary: '',

                      ),
                    ],
                  )),
                ],
              ),
            ),

          if (viewModel.history.isNotEmpty)
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
                  ...viewModel.history.map((city) => Column(
                    children: [
                      CityTile(
                        city: city,
                        onTap: () {
                          viewModel.selectCity(city);
                          mapViewModel.updateCity(city.name, city.location);
                          Navigator.pop(context);
                        },
                        isFavorite: viewModel.favorites.contains(city),
                        onFavoriteToggle: () => viewModel.addToFavorites(city),
                        cityAverage: mapViewModel.cityAverage(),
                        pollutantMeasure: mapViewModel.pollutantMeasure(),
                        airQualitySummary: '',
                      ),
                    ],
                  )),
                ],
              ),
            ),
        ],
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
