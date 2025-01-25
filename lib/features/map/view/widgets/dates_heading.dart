import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../repository/sensor_repository.dart';
import 'package:clean_breathe/features/common/static_info/colors_by_value.dart';

class DatesHeading extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const DatesHeading({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dayFormat = DateFormat('EEE');
    final dates = List<DateTime>.generate(5, (index) => today.subtract(Duration(days: index)),).reversed.toList();
    dates.insert(0, DateTime(0));

    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth / dates.length - 10;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dates.map((date) {
          final isExplore = date == DateTime(0);
          final dateLabel = isExplore
              ? "Explore" : (dateFormat.format(date) == dateFormat.format(today)
              ? "Today" : dayFormat.format(date));
          final dateString = isExplore ? null : dateFormat.format(date);
          final isSelected = dateString == selectedDate;

          return SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              onPressed: () async {
                if (isExplore) {
                  final pickedDate = await _showStyledDatePicker(context, today);
                  if (pickedDate != null) {
                    onDateSelected(dateFormat.format(pickedDate));
                  }
                } else if (dateString != null) {
                  onDateSelected(dateString);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.black : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 1,
                padding: EdgeInsets.zero,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isExplore)
                    const SizedBox(height: 5),
                  if (!isExplore)
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getAverageAndColor(date),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 10,
                            width: 10,
                            child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
                          );
                        }

                        if (snapshot.hasData) {
                          final color = snapshot.data!['color'];
                          final average = snapshot.data!['average'];

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: buttonSize * 0.8,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              Text(
                                average != null ? '${average.toInt().toString()}' : 'no data',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),

                  if (!isExplore) const SizedBox(height: 4),
                  if (isExplore)
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black,
                    ),
                  if (isExplore) const SizedBox(height: 4),
                  Text(
                    dateLabel.toUpperCase(),
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

  Future<DateTime?> _showStyledDatePicker(BuildContext context, DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor:Colors.black,
          ),
          child: child ?? Container(),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getAverageAndColor(DateTime date) async {
    final average = await SensorRepository().getAverageForDate(date);
    if(average == -10000.0){
      return {'average': null, 'color': Colors.grey};
    }
    final color = ColorByValue.get(average);
    return {'average': average, 'color': color};
  }
}
