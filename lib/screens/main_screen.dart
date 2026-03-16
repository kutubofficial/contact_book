import 'package:contact_book/screens/keypad_screen.dart';
import 'package:contact_book/screens/voicemail_screen.dart';
import 'package:flutter/material.dart';
import 'contacts_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 1;

  final _screens = const [FavoritesScreen(), ContactsScreen(), KeypadScreen(), VoicemailScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
              activeIcon: Icon(Icons.contacts),
              label: 'Contacts'),
              BottomNavigationBarItem(
              icon: Icon(Icons.window_sharp),
              activeIcon: Icon(Icons.window_sharp),
              label: 'Keypad'),
              BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over_outlined),
              activeIcon: Icon(Icons.record_voice_over),
              label: 'Voicemail'),
        ],
      ),
    );
  }
}