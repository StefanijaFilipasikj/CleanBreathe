import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_breathe/features/city/view-model/city_view_model.dart';
import 'package:clean_breathe/features/map/view-model/map_view_model.dart';

class SearchCityPage extends StatefulWidget {
  const SearchCityPage({Key? key}) : super(key: key);

  @override
  _SearchCityPageState createState() => _SearchCityPageState();
}

class _SearchCityPageState extends State<SearchCityPage> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CityViewModel>(context);
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              onChanged: (query) {
                if (_debounce?.isActive ?? false) {
                  _debounce?.cancel();
                }
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  viewModel.searchCities(query);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ...viewModel.searchResults.map((city) => ListTile(
                  title: Text(city.name),
                  onTap: () {
                    viewModel.addToHistory(city);
                    mapViewModel.updateCity(city.name, city.location, city.country);
                    Navigator.pop(context);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
