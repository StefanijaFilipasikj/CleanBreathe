import 'package:flutter/material.dart';

class CenterPositionButton extends StatelessWidget {
  final VoidCallback onPressed;

  CenterPositionButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      bottom: 55.0,
      right: 10.0,
      child: Container(
        width: 40.0,
        height: 40.0,
        child: FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(
            Icons.my_location,
            color: Colors.black,
            size: 30.0,
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}