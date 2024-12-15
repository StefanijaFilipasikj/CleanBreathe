import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sensor.dart';
import '../../common/utils/values.dart';

class SensorRepository {
  Future<List<Sensor>> fetchSensors(String cityName, String valueType, String dateString) async {
    final DateTime date = DateTime.parse(dateString);
    final String from = "${date.toIso8601String().split('T')[0]}T00:00:00%2b01:00"; //TODO: make timezone offset dynamic
    final String to = "${date.toIso8601String().split('T')[0]}T23:59:59%2b01:00";
    final url = Uri.parse("https://$cityName.pulse.eco/rest/dataRaw?type=$valueType&from=$from&to=$to");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        final groupedData = _groupSensorData(data);

        return groupedData.entries
          .map((entry) => Sensor(
            sensorId: entry.key,
            type: valueType,
            value: entry.value['average'],
            latitude: entry.value['latitude'],
            longitude: entry.value['longitude'],
            timeStamp: entry.value['latestTime'],
        )).toList();

      } else {
        throw Exception("Failed to load sensors");
      }
    } catch (e) {
      throw Exception("Error fetching sensors: $e");
    }
  }

  Map<String, Map<String, dynamic>> _groupSensorData(List<dynamic> data) {
    final Map<String, List<double>> sensorValues = {};
    final Map<String, Map<String, dynamic>> sensorInfo = {};

    for (var item in data) {
      final String sensorId = item['sensorId'];
      final double value = double.parse(item['value']);
      final position = item['position'].split(',');
      final double latitude = double.parse(position[0]);
      final double longitude = double.parse(position[1]);
      final DateTime timeStamp = DateTime.parse(item['stamp']);

      if (!sensorValues.containsKey(sensorId)) {
        sensorValues[sensorId] = [];
        sensorInfo[sensorId] = {
          'latitude': latitude,
          'longitude': longitude,
          'latestTime': timeStamp,
        };
      }
      sensorValues[sensorId]!.add(value);

      if (timeStamp.isAfter(sensorInfo[sensorId]!['latestTime'])) {
        sensorInfo[sensorId]!['latestTime'] = timeStamp;
      }
    }

    return sensorValues.map((sensorId, values) => MapEntry(
      sensorId,
      {
        ...sensorInfo[sensorId]!,
        'average': values.reduce((a, b) => a + b) / values.length,
      },
    ));
  }

  Future<double> getAverageForDate(DateTime date) async {
    String cityName = Values.city;
    String valueType = Values.valueType;

    final String from = "${date.toIso8601String().split('T')[0]}T00:00:00%2b01:00";
    String to = "${date.toIso8601String().split('T')[0]}T23:59:59%2b01:00";

    final url = Uri.parse("https://$cityName.pulse.eco/rest/dataRaw?type=$valueType&from=$from&to=$to");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if(data.isEmpty){
          return -10000.0;
        }
        return data.map((sensor) => double.parse(sensor['value'])).reduce((a, b) => a + b) / data.length;
      } else {
        throw Exception("Failed to load sensors");
      }
    } catch (e) {
      throw Exception("Error fetching sensors: $e");
    }
  }
}
