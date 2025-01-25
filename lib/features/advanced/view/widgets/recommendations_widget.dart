import 'package:flutter/material.dart';
import '../../../common/static_info/colors_by_value.dart';
import '../../../common/utils/values.dart';
import '../../../common/static_info/recommendations_by_average.dart';

class RecommendationsWidget extends StatefulWidget {
  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations By Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: expandedIndex == -1
              ? _buildCompactRecommendations()
              : _buildExpandedRecommendation(),
        ),
      ],
    );
  }

  Widget _buildCompactRecommendations() {
    final recommendations = Recommendation.getRecommendationForValue();

    return Row(
      key: ValueKey('compact'),
      children: List.generate(recommendations.length, (index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 33),
          child: GestureDetector(
            onTap: () {
              setState(() {
                expandedIndex = index;
              });
            },
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.center,
              child: Icon(
                recommendations[index]['icon'] as IconData,
                size: 25,
                color: ColorByValue.get(Values.average),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildExpandedRecommendation() {
    final recommendations = Recommendation.getRecommendationForValue();

    return AnimatedContainer(
      key: ValueKey('expanded'),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            expandedIndex = -1;
          });
        },
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              alignment: Alignment.center,
              child: Icon(
                recommendations[expandedIndex]['icon'] as IconData,
                size: 25,
                color: ColorByValue.get(Values.average),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  recommendations[expandedIndex]['text'] as String,
                  style: TextStyle(fontSize: 12.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
