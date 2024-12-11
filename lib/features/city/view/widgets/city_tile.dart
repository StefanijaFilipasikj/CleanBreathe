import 'package:clean_breathe/features/city/model/city.dart';
import 'package:clean_breathe/features/common/average_display/view/widgets/average_in_city.dart';
import 'package:clean_breathe/features/map/view-model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityTile extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final double cityAverage;
  final String pollutantMeasure;

  const CityTile({
    Key? key,
    required this.city,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.cityAverage,
    required this.pollutantMeasure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onTap: onTap,
      leading: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.black : null,
        ),
        onPressed: onFavoriteToggle,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side content with city name, country, and summary
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  city.country,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<String>(
                  future: mapViewModel.averageForCity(city.name),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('No data available');
                    } else if (snapshot.hasData) {
                      return AverageInCityDisplay(
                        double.tryParse(snapshot.data!) ?? 0.0,
                        pollutantMeasure,
                        false
                      );
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
