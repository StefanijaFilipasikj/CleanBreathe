import 'package:clean_breathe/features/common/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../repository/advanced_repository.dart';
import '../../../common/static_info/colors_by_value.dart';
import '../../../common/static_info/value_type_limits.dart';
import '../../model/hourly_average_value.dart';

class GraphWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Hourly Measurements',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        _buildGraph(),
      ],
    );
  }

  Widget _buildGraph() {
    return FutureBuilder<List<HourlyAverageValue>>(
      future: AdvancedRepository().getValueHistory(Values.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available for today'));
        } else {
          List<HourlyAverageValue> history = snapshot.data!;
          List<FlSpot> spots = history
              .map((entry) => FlSpot(
              entry.timestamp.hour.toDouble(), entry.value.toDouble()))
              .toList();

          List<Color> colors = spots.map((spot) {
            return ColorByValue.get(spot.y);
          }).toList();

          List<LineChartBarData> lineBars =
          List.generate(spots.length, (index) {
            return LineChartBarData(
              spots: [spots[index]],
              isCurved: true,
              color: colors[index],
              barWidth: 3,
            );
          });

          final now = DateTime.now();

          return SizedBox(
            height: 170,
            width: 310,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        final isToday = Values.date.toString().split(' ')[0] == DateTime.now().toString().split(' ')[0];
                        final hour = isToday
                            ? (value.toInt() + DateTime.now().hour) % 24
                            : value.toInt();
                        final show = value.toInt() != -1;
                        final isNow = isToday && value.toInt() == 24;
                        return Padding(
                            padding: const EdgeInsets.only(right: 7.0, top: 4.0),
                            child: show ? Text(
                              isNow ? "now" : "${hour.toInt().toString().padLeft(2, '0')}:00",
                              style: TextStyle(fontSize: 11),
                            )
                                : SizedBox.shrink()
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: Limits.interval(),
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: -1,
                maxX: 24,
                minY: Limits.min(),
                maxY: Limits.max(),
                lineBarsData: lineBars,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => ColorByValue.get(touchedSpot.y),
                    tooltipPadding: EdgeInsets.all(10),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final value = touchedSpot.y;
                        return LineTooltipItem(
                          "average: " + value.toInt().toString(),
                          TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
