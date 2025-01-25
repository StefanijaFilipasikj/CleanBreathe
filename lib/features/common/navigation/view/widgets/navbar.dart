import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../city/view/pages/city_selection_page.dart';
import '../../../../auth/LoginPage.dart';
import '../../../../map/view/pages/map_page.dart';

class NavBar extends StatelessWidget {
  final String? cityName;

  const NavBar({Key? key, this.cityName}) : super(key: key);

  Future<bool> _getUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('user_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _getUserLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading user status'));
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
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
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        if (isLoggedIn) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('user_logged_in', false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MapPage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      child: Icon(
                        isLoggedIn ? Icons.logout_outlined : Icons.person_outline,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
