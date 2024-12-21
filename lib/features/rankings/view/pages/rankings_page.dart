import 'package:flutter/material.dart';
import '../../repository/rankings_repository.dart';
import '../../model/city_ranking.dart';
import '../../../common/static_info/colors_by_value.dart';
import '../../../common/static_info/flags.dart';

class RankingsPage extends StatefulWidget {

  const RankingsPage({super.key});

  @override
  _RankingsPageState createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  late Future<List<CityRanking>> _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = RankingsRepository().getRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City Rankings"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CityRanking>>(
        future: _rankingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),));
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
                        style: TextStyle(
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
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "${ranking.average}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
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
