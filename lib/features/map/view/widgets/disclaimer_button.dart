import 'package:flutter/material.dart';

class DisclaimerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DisclaimerButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.0,
      right: 10.0,
      child: Container(
        width: 100.0,
        height: 35.0,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Disclaimer',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}