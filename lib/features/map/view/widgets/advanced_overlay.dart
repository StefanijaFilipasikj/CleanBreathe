//If we aren't considering this as a map widget, the file should be moved

import 'package:flutter/material.dart';
import '../../../advanced/view/pages/advanced_page.dart';

class AdvancedOverlayWidget extends StatelessWidget {
  final VoidCallback toggleAdvancedInformation;

  const AdvancedOverlayWidget({Key? key, required this.toggleAdvancedInformation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          // onTap: toggleAdvancedInformation,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            margin: EdgeInsets.only(bottom: 70.0),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 60.0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.zero),
            ),
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.69,
            child: AdvancedInfoContent(),
          ),
        ),
      ],
    );
  }
}
