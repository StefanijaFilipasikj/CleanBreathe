import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatefulWidget {
  final VoidCallback _mapCallback;
  final VoidCallback _devicesCallback;
  final VoidCallback _advancedInformationCallback;
  final VoidCallback _rankingsCallback;

  BottomButtons([
    this._mapCallback = _defaultCallback,
    this._devicesCallback = _defaultCallback,
    this._advancedInformationCallback = _defaultCallback,
    this._rankingsCallback = _defaultCallback
  ]);

  static void _defaultCallback() {}

  @override
  _BottomButtonsState createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  int _selectedIndex = -1;

  void _toggleSelection(int index) {
    setState(() {
      if(index != 2 && _selectedIndex == 2){ //if advanced was clicked then something else - hide advanced
        widget._advancedInformationCallback();
      }
      _selectedIndex = (_selectedIndex == index) ? 0 : index; //if something was un-clicked go back to map (0)
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bottomButtonsInfo = [
      {"icon": FontAwesomeIcons.map, "label": "Map", "onPressed": widget._mapCallback},
      {"icon": FontAwesomeIcons.plus, "label": "Devices", "onPressed": widget._devicesCallback},
      {"icon": FontAwesomeIcons.chartLine, "label": "Advanced", "onPressed": widget._advancedInformationCallback},
      {"icon": FontAwesomeIcons.rankingStar, "label": "Rankings", "onPressed": widget._rankingsCallback},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.085,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: bottomButtonsInfo.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> buttonInfo = entry.value;

          bool isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              _toggleSelection(index);
              buttonInfo["onPressed"]();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  buttonInfo["icon"] as IconData,
                  color: isSelected ? Colors.green : Colors.black,
                  size: 30,
                ),
                Text(
                  buttonInfo["label"] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
