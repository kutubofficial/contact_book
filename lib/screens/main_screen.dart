import 'package:contact_book/screens/keypad_screen.dart';
import 'package:contact_book/screens/voicemail_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'contacts_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 1;

  final _screens = const [
    FavoritesScreen(),
    ContactsScreen(),
    KeypadScreen(),
    VoicemailScreen(),
  ];

  static const _navItems = [
    (icon: Icons.star, activeIcon: Icons.star,label: 'Favorites'), 
    (icon: Icons.contacts,activeIcon: Icons.contacts,label: 'Contacts'), 
    (icon: Icons.window_sharp,activeIcon: Icons.window_sharp,label: 'Keypad'),
    (icon: Icons.record_voice_over,activeIcon: Icons.record_voice_over,label: 'Voicemail'), 
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark,
    // ));

    return Scaffold(
      body: _screens[_index],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: const Color(0xFF6C5CE7),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, 
          items: _navItems.map((item) => 
          _buildNavItem(icon: item.icon,activeIcon: item.activeIcon,label: item.label,)).toList(),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }
}