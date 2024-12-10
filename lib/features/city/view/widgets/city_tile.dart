import 'package:clean_breathe/features/city/model/city.dart';
import 'package:flutter/material.dart';
import 'package:clean_breathe/features/map/view/widgets/average_in_city.dart'; // Import the widget

class CityTile extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final double cityAverage;
  final String pollutantMeasure;
  final String airQualitySummary;

  const CityTile({
    Key? key,
    required this.city,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.cityAverage,
    required this.pollutantMeasure,
    required this.airQualitySummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onTap: onTap,
      leading: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
        onPressed: onFavoriteToggle,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
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
                SizedBox(height: 4),
                Text(
                  'Summary $airQualitySummary',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: AverageInCityDisplay(cityAverage, pollutantMeasure),
          ),
        ],
      ),
    );
  }
}
