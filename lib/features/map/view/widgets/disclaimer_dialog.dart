import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisclaimerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Disclaimer',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The data presented is crowdsourced. We do not guarantee its correctness. '
                      'The third-party sensor data is stored as received from their service, while '
                      'the pulse.eco devices depend on the correctness of the used sensors and the '
                      'conditions in their nearest surroundings. Please refer to the FAQ for details.',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}