import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/sensor.dart';

class SensorRepository {
  Future<List<Sensor>> fetchSensors(String cityName) async {
    final url = Uri.parse("https://$cityName.pulse.eco/rest/current");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return data.map((json) => Sensor.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load sensors");
      }
    } catch (e) {
      throw Exception("Error fetching sensors: $e");
    }
  }
}
