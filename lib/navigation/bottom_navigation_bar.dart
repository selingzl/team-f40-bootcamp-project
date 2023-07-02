import 'package:flutter/material.dart';
import 'package:read_reminder/screens/library_screen.dart';
import 'package:read_reminder/screens/profile_screen.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    LibraryScreen(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/icons/ic_time.png',
              width: 40,
              height: 40,
            ),
            label: 'Sayaç',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/icons/ic_add.png',
              width: 40,
              height: 40,
            ),
            label: 'Bağış',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/icons/ic_book.png',
              width: 40,
              height: 40,
            ),
            label: 'Kitaplık',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/icons/ic_profile.png',
              width: 40,
              height: 40,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}
