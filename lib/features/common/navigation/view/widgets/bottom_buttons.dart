import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.map_outlined,
      Icons.filter_alt_outlined,
      Icons.add_circle_outline,
      Icons.insert_chart_outlined
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.map((icon) {
          return ElevatedButton(
            onPressed: () {
              // TODO Add action
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(65, 65),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.grey[200],
              elevation: 4,
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 35,
            ),
          );
        }).toList(),
      ),
    );
  }
}
