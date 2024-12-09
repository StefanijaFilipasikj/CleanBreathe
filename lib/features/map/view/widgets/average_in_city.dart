import 'package:clean_breathe/features/common/utils/get_color_for_value.dart';
import 'package:clean_breathe/features/common/utils/get_text_for_value.dart';
import 'package:flutter/material.dart';

class AverageInCityDisplay extends StatefulWidget {
  final double average;
  final String measure;

  const AverageInCityDisplay(this.average, this.measure, {Key? key}) : super(key: key);

  @override
  _AverageInCityDisplayState createState() => _AverageInCityDisplayState();
}

class _AverageInCityDisplayState extends State<AverageInCityDisplay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GetColorForValue.get(widget.average),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 3)),],
              ),
              width: _isExpanded ? 390 : 140,
              height: _isExpanded ? 115 : 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Average",
                        style: TextStyle(
                          fontSize: _isExpanded ? 16 : 14,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.average.toInt()}",
                            style: TextStyle(
                              fontSize: _isExpanded ? 32 : 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.measure,
                            style: TextStyle(
                              fontSize: _isExpanded ? 14 : 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_isExpanded) ...[
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        GetTextForValue.get(widget.average),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Icon(
              _isExpanded ? Icons.zoom_in_map : Icons.zoom_out_map,
              color: Colors.white,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}