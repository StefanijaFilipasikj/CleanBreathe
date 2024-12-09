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
    final pollutants = ["pm10", "pm25", "temperature", "humidity", "pressure"];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: pollutants.map((pollutant) {
            final isSelected = pollutant == selectedPollutant;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: () => onPollutantSelected(pollutant),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.black : Colors.white,
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  pollutant.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
