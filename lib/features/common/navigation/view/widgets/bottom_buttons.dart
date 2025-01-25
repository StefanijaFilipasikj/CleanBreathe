import 'package:clean_breathe/features/auth/LoginPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomButtons extends StatefulWidget {
  final VoidCallback mapCallback;
  final VoidCallback devicesCallback;
  final VoidCallback advancedInformationCallback;
  final VoidCallback rankingsCallback;

  BottomButtons({
  Key? key,
  this.mapCallback = _defaultCallback,
  this.devicesCallback = _defaultCallback,
  this.advancedInformationCallback = _defaultCallback,
  this.rankingsCallback = _defaultCallback
  }) : super(key: key);

  static void _defaultCallback() {}

  @override
  BottomButtonsState createState() => BottomButtonsState();
}

class BottomButtonsState extends State<BottomButtons> {
  int _selectedIndex = 0;

  void resetSelectedIndex() {
    setState(() {
      _selectedIndex = 0; // map
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if(index != 2 && _selectedIndex == 2){ //if advanced was clicked then something else - hide advanced
        widget.advancedInformationCallback();
      }
      _selectedIndex = (_selectedIndex == index) ? 0 : index; //if something was un-clicked go back to map (0)
    });
  }

  Future<void> _handleDevicesPressed(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('user_logged_in') ?? false;

    if (isLoggedIn) {
      widget.devicesCallback();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bottomButtonsInfo = [
      {"icon": FontAwesomeIcons.map, "label": "Map", "onPressed": widget.mapCallback},
      {"icon": FontAwesomeIcons.plus, "label": "Devices", "onPressed": () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('login_redirect', 'devices');
          _handleDevicesPressed(context);
        }
      },
      {"icon": FontAwesomeIcons.chartLine, "label": "Advanced", "onPressed": widget.advancedInformationCallback},
      {"icon": FontAwesomeIcons.rankingStar, "label": "Rankings", "onPressed": widget.rankingsCallback},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
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
                  size: 28,
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
