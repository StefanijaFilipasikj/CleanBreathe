import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final dates = List<DateTime>.generate(4, (index) => today.subtract(Duration(days: index)),).reversed.toList();
    dates.insert(0, DateTime(0));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dates.map((date) {
            final isExplore = date == DateTime(0);
            final dateLabel = isExplore
                ? "Explore" : (dateFormat.format(date) == dateFormat.format(today)
                ? "Today" : dayFormat.format(date));
            final dateString = isExplore
                ? null : dateFormat.format(date);
            final isSelected = dateString == selectedDate;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  dateLabel.toUpperCase(),
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
}
