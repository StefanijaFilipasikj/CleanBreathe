import 'package:flutter/material.dart';
import 'features/common/navigation/view/widgets/navbar.dart';
import 'features/map/view/pages/map_view.dart';
import 'features/intro-loading/view/pages/loading_screen.dart'; // Import the loading screen widget

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
