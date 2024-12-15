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
          color: Colors.white,
          padding: EdgeInsets.all(2.0),
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
                    size: 30,
                  ),
                ],
              ),
            ),
        ),
      ]
    );
  }
}