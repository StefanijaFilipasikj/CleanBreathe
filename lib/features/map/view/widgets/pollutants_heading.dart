import 'package:flutter/material.dart';

class PollutantsHeading extends StatelessWidget {
  final String selectedPollutant;
  final Function(String) onPollutantSelected;

  const PollutantsHeading({
    Key? key,
    required this.selectedPollutant,
    required this.onPollutantSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pollutants = [
      {"label": "pm10", "name": "pm10", "icon": Icons.scatter_plot},
      {"label": "pm2.5", "name": "pm25", "icon": "assets/images/pm25_icon.png"},
      {"label": "temp", "name": "temperature", "icon": Icons.thermostat},
      {"label": "humidity", "name": "humidity", "icon": Icons.water_drop},
      {"label": "pressure", "name": "pressure", "icon": "assets/images/pressure_icon.png"},
      {"label": "noise", "name": "noise", "icon": "assets/images/noise_icon.png"},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth - (pollutants.length * 10)) / pollutants.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: pollutants.map((pollutant) {
          final label = pollutant["label"] as String;
          final name = pollutant["name"] as String;
          final icon = name == "pm25" || name == "noise" || name == "pressure" ? pollutant["icon"] as String : pollutant["icon"] as IconData;
          final isSelected = name == selectedPollutant;

          return SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              onPressed: () => onPollutantSelected(name),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.black : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 1,
                shadowColor: isSelected ? Colors.black : Colors.grey.shade400,
                padding: EdgeInsets.zero,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  name == "pm25" || name == "noise" || name == "pressure" ?
                    Image.asset(
                      icon as String,
                      width: 18,
                      height: 18,
                      color: isSelected ? Colors.white : Colors.black,
                    ) :
                    Icon(
                      icon as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
