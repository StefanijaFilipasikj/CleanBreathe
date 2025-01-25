import 'package:clean_breathe/features/map/view-model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/rankings_repository.dart';
import '../../model/city_ranking.dart';
import '../../../common/static_info/colors_by_value.dart';
import '../../../common/static_info/flags.dart';
import '../../../common/utils/values.dart';
import '../../../common/utils/change_value_to_unit.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});

  @override
  _RankingsPageState createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  late Future<List<CityRanking>> _rankingsFuture;
  String _currentRankingType = Values.valueType;
  final pollutants = ["pm10", "pm25", "temperature", "humidity", "pressure", "noise"];

  @override
  void initState() {
    super.initState();
    _fetchRankings();
  }

  void _fetchRankings() {
    _rankingsFuture = RankingsRepository().getRankings();
  }

  @override
  Widget build(BuildContext context) {

    final mapViewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("City Rankings"),
        centerTitle: true,
        actions: [
          Container(
            width: 120,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: _currentRankingType,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.transparent),
                alignment: Alignment.centerRight,
                onChanged: (String? newType) {
                  if (newType != null) {
                    setState(() {
                      _currentRankingType = newType;
                      Values.valueType = newType;
                      _fetchRankings();
                      mapViewModel.changePollutant(newType);
                    });
                  }
                },
                items: pollutants.map((String pollutant) {
                  return DropdownMenuItem<String>(
                    value: pollutant,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        pollutant,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return pollutants.map<Widget>((String pollutant) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        pollutant,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<CityRanking>>(
        future: _rankingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No rankings available"),
            );
          }

          List<CityRanking> rankings = snapshot.data!;
          rankings.sort((a, b) => b.average.compareTo(a.average));

          return ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              final ranking = rankings[index];
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}. ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Image.network(
                      getFlagUrl(ranking.country),
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                title: Text(
                  ranking.city,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(ranking.country),
                trailing: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColorByValue(ranking.average),
                  ),
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${ranking.average}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          changeValueToUnit(_currentRankingType),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  mapViewModel.updateCityByName(ranking.city);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  Color getColorByValue(int average) {
    return ColorByValue.get(average.toDouble());
  }

  String getFlagUrl(String country) {
    return Flags.get(country);
  }
}
