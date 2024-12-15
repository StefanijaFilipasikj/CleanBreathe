import 'package:flutter/material.dart';

import '../../../../city/view/pages/city_selection_page.dart';

class NavBar extends StatelessWidget {
  final String? cityName;

  const NavBar({Key? key, this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CitySelectionPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  Flexible(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                cityName ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: const Text(
              "pulse.eco",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
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
            ),
          ),
        ],
      ),
    );
  }

  //TODO Add languages that we will use
  void showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Language"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
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
