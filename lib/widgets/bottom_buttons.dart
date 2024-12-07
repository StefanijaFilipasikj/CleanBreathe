import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.home,
      Icons.settings,
      Icons.add_box_outlined,
      Icons.add_chart
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.map((icon) {
          return ElevatedButton(
            onPressed: () {
              // TODO Add action
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(70, 70), // Square buttons
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              backgroundColor: Colors.grey[200],
              elevation: 4,
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 30, // Icon size
            ),
          );
        }).toList(),
      ),
    );
  }
}
