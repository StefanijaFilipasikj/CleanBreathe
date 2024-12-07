import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Handle city selection
              showCitySelectionDialog(context);
            },
            child: Row(
              children: const [
                Text(
                  "City",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),

          const Text(
            "pulse.eco",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: () {
              // TODO: Handle language selection
              showLanguageSelectionDialog(context);
            },
            child: const Icon(
              Icons.language,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }


  //TODO Make this dynamic
  void showCitySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select a City"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Skopje"),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Set city to Skopje
                },
              ),
              ListTile(
                title: const Text("Bitola"),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Set city to Bitola
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //TODO Add languages that we will use
  void showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Set language to English
                },
              ),
              ListTile(
                title: const Text("Macedonian"),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Set language to Macedonian
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
