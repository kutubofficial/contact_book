import 'package:flutter/material.dart';

class VoicemailScreen extends StatelessWidget {
  const VoicemailScreen({super.key});

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
              child: Text('Voicemail',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child:  const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.record_voice_over_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No contacts yet',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text(
                              'Open a contact and tap\n"Add to Voicemail" to see them here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    )
            ),
          ],
        ),
      ),
    );
  }
}
