import 'dart:convert';
import 'package:clean_breathe/features/common/utils/values.dart';
import 'package:clean_breathe/features/rankings/model/city_ranking.dart';
import 'package:http/http.dart' as http;

class RankingsRepository {

  Map<String, String> citiesByCountry = {
    "Skopje": "North Macedonia",
    "Bitola": "North Macedonia",
    "Ohrid": "North Macedonia",
    "Tetovo": "North Macedonia",
    "Kumanovo": "North Macedonia",
    "Resen": "North Macedonia",
    "Novo Selo": "North Macedonia",
    "Struga": "North Macedonia",
    "Star Dojran": "North Macedonia",
    "Shtip": "North Macedonia",
    "Gostivar": "North Macedonia",
    "Strumica": "North Macedonia",
    "Bogdanci": "North Macedonia",
    "Kichevo": "North Macedonia",
    "Tirana": "Albania",
    "Sofia": "Bulgaria",
    "Yambol": "Bulgaria",
    "Zagreb": "Croatia",
    "Nicosia":"Cyprus",
    "Copenhagen":"Denmark",
    "Berlin":"Germany",
    "Magdeburg":"Germany",
    "Syros":"Greece",
    "Thessaloniki":"Greece",
    "Cork":"Ireland",
    "Chisinau":"Romania",
    "Nis":"Serbia",
    "Lausanne":"Switzerland",
    "Zurich":"Switzerland",
    "Zuchwil":"Switzerland",
    "Bern":"Switzerland",
    "Luzern":"Switzerland",
    "Grenchen":"Switzerland",
    "Grand Rapids":"USA",
    "Portland":"USA",
  };


  Future<List<CityRanking>> getRankings() async {
    final now = DateTime.now();
    final from = now.subtract(Duration(hours: 24)).toIso8601String().split('T')[0] + "T${now.subtract(Duration(hours: 24)).hour.toString().padLeft(2, '0')}:${now.subtract(Duration(hours: 24)).minute.toString().padLeft(2, '0')}:00%2b01:00";
    final to = now.toIso8601String().split('T')[0] + "T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:59%2b01:00";

    final cityRankingFutures = citiesByCountry.entries.map((entry) {
      return fetchRanking(entry.key, entry.value, Values.valueType, from, to);
    });

    final results = await Future.wait(cityRankingFutures);
    return results.whereType<CityRanking>().toList();
  }


  Future<CityRanking?> fetchRanking(String city, String country, String valueType, String from, String to) async {
    String cityName = city.replaceAll(" ", "").toLowerCase();
    final url = Uri.parse("https://$cityName.pulse.eco/rest/dataRaw?type=$valueType&from=$from&to=$to");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        if (data.isEmpty) {
          print("No data available for $city.");
          return null;
        }

        final average = data.map((sensor) => double.parse(sensor['value'].toString())).reduce((a, b) => a + b) / data.length;
        return CityRanking(city, country, average.toInt());
      } else {
        print("Failed to load data for $city: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching data for $city: $e");
      return null;
    }
  }
}