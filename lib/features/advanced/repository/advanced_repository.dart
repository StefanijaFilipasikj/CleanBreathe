import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/utils/values.dart';
import '../model/hourly_average_value.dart';
import '../../common/static_info/value_type_limits.dart';

class AdvancedRepository {

  Future<List<HourlyAverageValue>> getValueHistory(DateTime date) async {
    final from = date.subtract(Duration(hours: 24)).toIso8601String().split('T')[0] + "T${date.subtract(Duration(hours: 24)).hour.toString().padLeft(2, '0')}:${date.subtract(Duration(hours: 24)).minute.toString().padLeft(2, '0')}:00%2b01:00";
    final to = date.toIso8601String().split('T')[0] + "T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:59%2b01:00";

    String cityName = Values.city;
    String valueType = Values.valueType;

    final url = Uri.parse("https://$cityName.pulse.eco/rest/dataRaw?type=$valueType&from=$from&to=$to");

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

          if (average >= Limits.maxMap[valueType]!){
            Limits.maxMap[valueType] = (((average + 9) ~/ 10) * 10) + 10; //next larger number divisible by 10 + 10 for padding
          }
          else if (average <= Limits.minMap[valueType]!){
            Limits.minMap[valueType] = ((average ~/ 10) * 10) - 10; //previous smaller number divisible by 10 - 10 for padding
          }

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
