import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/utils/values.dart';
import '../model/hourly_average_value.dart';

class AdvancedRepository {

  Future<List<HourlyAverageValue>> getValueHistory() async {

    //TODO: find a better way of formatting the dates for the api call
    final now = DateTime.now();
    final from = now.subtract(Duration(hours: 24)).toIso8601String().split('T')[0] + "T${now.subtract(Duration(hours: 24)).hour.toString().padLeft(2, '0')}:${now.subtract(Duration(hours: 24)).minute.toString().padLeft(2, '0')}:00%2b01:00";
    final to = now.toIso8601String().split('T')[0] + "T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:59%2b01:00";

    String cityName = Values.city;
    String valueType = Values.valueType;

    final url = Uri.parse("https://$cityName.pulse.eco/rest/dataRaw?type=$valueType&from=$from&to=$to");
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        Map<int, List<HourlyAverageValue>> hourlyData = {};
        for (var el in data) {
          HourlyAverageValue valueByHour = HourlyAverageValue.fromJson(el);
          int hour = valueByHour.timestamp.hour;

          if (!hourlyData.containsKey(hour)) {
            hourlyData[hour] = [];
          }
          hourlyData[hour]!.add(valueByHour);
        }

        List<HourlyAverageValue> hourlyAverages = [];
        for (var entry in hourlyData.entries) {
          int hour = entry.key;
          List<HourlyAverageValue> values = entry.value;
          double average = values.map((el) => el.value).reduce((a, b) => a + b) / values.length;
          DateTime hourTimestamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour);
          hourlyAverages.add(HourlyAverageValue(timestamp: hourTimestamp, value: average));
        }

        return hourlyAverages;

      } else {
        throw Exception("Failed to load sensors");
      }
    } catch (e) {
      throw Exception("Error fetching sensors: $e");
    }
  }
}
