// KeypadScreen

import 'package:flutter/material.dart';
class KeypadScreen extends StatelessWidget {
  const KeypadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text('Dial Pad',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            // Add keypad UI elements here
          ],
        ),
      ),
    );
  }
}
