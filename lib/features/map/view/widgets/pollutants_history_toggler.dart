import 'package:flutter/material.dart';

class PollutantsHistoryToggler extends StatelessWidget {
  VoidCallback _onTap;
  bool _areOptionsActive;

  PollutantsHistoryToggler(this._onTap, this._areOptionsActive);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Color.fromRGBO(255, 255, 255, 0.8),
          padding: EdgeInsets.all(0.0),
          child:
            GestureDetector(
              onTap: _onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _areOptionsActive
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 28,
                  ),
                ],
              ),
            ),
        ),
      ]
    );
  }
}