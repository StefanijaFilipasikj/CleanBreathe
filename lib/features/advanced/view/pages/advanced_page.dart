import 'package:flutter/material.dart';
import '../../../common/utils/values.dart';
import '../../../common/static_info/value_type_descriptions.dart';
import '../widgets/recommendations_widget.dart';
import '../widgets/graph_widget.dart';
import '../widgets/colorscale_widget.dart';

class AdvancedInfoContent extends StatefulWidget {
  @override
  _AdvancedPageState createState() => _AdvancedPageState();
}

class _AdvancedPageState extends State<AdvancedInfoContent> {
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Advanced Information - ' + Values.valueType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 14),
          Text(Descriptions.get(), style: TextStyle(fontSize: 12.5)),
          SizedBox(height: 14),
          RecommendationsWidget(),
          SizedBox(height: 14),
          GraphWidget(),
          SizedBox(height: 14),
          ColorScaleWidget(),
        ],
      ),
    );
  }
}
