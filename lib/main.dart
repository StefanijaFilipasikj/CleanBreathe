import 'package:clean_breathe/features/city/repository/city_repository.dart';
import 'package:clean_breathe/features/devices/view-model/device_view_model.dart';
import 'package:clean_breathe/features/map/repository/sensor_repository.dart';
import 'package:clean_breathe/features/map/view-model/map_view_model.dart';
import 'package:clean_breathe/features/map/view-model/toggling_view_model.dart';
import 'package:flutter/material.dart';
import 'features/city/view-model/city_view_model.dart';
import 'features/intro-loading/view/pages/loading_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MapViewModel(SensorRepository(), CityRepository())..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => CityViewModel(),
        ),
        ChangeNotifierProvider(
            create: (_) => TogglingViewModel()
        ),
        ChangeNotifierProvider(
            create: (_) => DeviceViewModel()
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
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.green,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          labelStyle: TextStyle(
            color: Colors.black87
          ),
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}
