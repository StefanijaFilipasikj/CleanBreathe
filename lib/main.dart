import 'package:clean_breathe/features/map/repository/sensor_repository.dart';
import 'package:clean_breathe/features/map/view-model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'features/city/view-model/city_view_model.dart';
import 'features/intro-loading/view/pages/loading_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MapViewModel(SensorRepository())..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => CityViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
