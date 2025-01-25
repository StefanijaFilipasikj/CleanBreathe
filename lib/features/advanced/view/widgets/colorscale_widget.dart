import 'package:flutter/material.dart';
import '../../../common/static_info/colorscales.dart';

class ColorScaleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Scale',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2),
        _buildColorScale(),
      ],
    );
  }

  Widget _buildColorScale() {
    final List<Map<String, dynamic>> colorSegments = ColorScale.get();

    final double minValue = colorSegments.map((segment) {
      return double.parse(segment['label'].split(' ')[0]);
    }).reduce((a, b) => a < b ? a : b);

    final double maxValue = colorSegments.map((segment) {
      return double.parse(segment['label'].split(' ')[0]);
    }).reduce((a, b) => a > b ? a : b);

    final double totalRange = maxValue - minValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Row(
            children: List.generate(colorSegments.length - 1, (index) {

              final segment = colorSegments[index];
              final Color startColor = segment['color'] as Color;
              final Color endColor = colorSegments[index + 1]['color'] as Color;

              return Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [startColor, endColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.3, 1.0],
                    ),
                  ),
                ),
              );

            }),
          ),
        ),
        SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: 15,
              child: Stack(
                children: List.generate(colorSegments.length, (index) {

                  final segment = colorSegments[index];
                  final double value = double.parse(segment['label'].split(' ')[0]);
                  final double position = ((value - minValue) / totalRange) * constraints.maxWidth;

                  return Positioned(
                    left: position.clamp(0, constraints.maxWidth - 40),
                    child: Text(
                      segment['label'] as String,
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }
}
