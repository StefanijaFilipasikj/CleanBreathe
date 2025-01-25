import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../map/view/pages/map_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMapPage();
  }

  Future<void> _navigateToMapPage() async {
    // Simulate a 1.5-second loading time
    await Future.delayed(const Duration(milliseconds: 1500));
    // Navigate to the main screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/pulse-logo.svg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),

            const Text(
              "pulse.eco",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              "• for the future minded •",
              style: TextStyle(
                fontFamily: 'DancingScript',
                color: Colors.white,
                fontSize: 25,
                fontStyle: FontStyle.normal,
              ),
            ),
            const SizedBox(height: 40),

            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
