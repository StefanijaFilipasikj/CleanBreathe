import 'package:flutter/material.dart';
import 'widgets/navbar.dart';
import 'widgets/map_view.dart';
import 'widgets/bottom_buttons.dart';
import 'widgets/loading_screen.dart'; // Import the loading screen widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
