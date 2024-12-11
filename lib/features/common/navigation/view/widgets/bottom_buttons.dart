import 'package:clean_breathe/features/common/navigation/model/bottom_button_information.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  VoidCallback _mapOptionsCallback;

  BottomButtons([this._mapOptionsCallback=_defaultCallback]);

  static void _defaultCallback() {}

  @override
  Widget build(BuildContext context) {
    final List<BottomButtonInformation> bottomButtonsInfo = [
      BottomButtonInformation(Icons.map_outlined, _defaultCallback),
      BottomButtonInformation(Icons.filter_alt_outlined, _mapOptionsCallback),
      BottomButtonInformation(Icons.add_circle_outline, _defaultCallback),
      BottomButtonInformation(Icons.insert_chart_outlined, _defaultCallback),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: bottomButtonsInfo.map((buttonInfo) {
          return ElevatedButton(
            onPressed: buttonInfo.onPressed,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(65, 65),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.grey[200],
              elevation: 4,
            ),
            child: Icon(
              buttonInfo.image,
              color: Colors.black,
              size: 35,
            ),
          );
        }).toList(),
      ),
    );
  }
}
