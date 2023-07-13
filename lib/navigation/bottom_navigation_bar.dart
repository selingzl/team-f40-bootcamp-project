import 'package:flutter/material.dart';
import 'package:read_reminder/screens/library_screen.dart';
import 'package:read_reminder/screens/profile_screen.dart';
import 'package:read_reminder/screens/timer_screen.dart';

import '../screens/book_screen.dart';

class BottomNavigationBarPage extends StatefulWidget {
  final String titleOfBook;
  const BottomNavigationBarPage({super.key, String? titleOfBook})
      : titleOfBook = titleOfBook ?? '';

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;
  late String bookTitle;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    bookTitle = widget.titleOfBook;
    _widgetOptions = <Widget>[
      TimerPage(bookName: bookTitle),
      BookPage(),
      LibraryScreen(),
      ProfilePage()
    ];
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /*static const List<Widget> _widgetOptions = <Widget>[
    TimerPage(bookName: bookTitle),
    BookPage(),
    LibraryScreen(),
    ProfilePage()
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(185, 187, 223, 1),
              Color.fromRGBO(223, 244, 243, 1),
              Color.fromRGBO(185, 187, 223, 1),
            ],

          ),
        ),
        child: Stack(children: [_widgetOptions[_selectedIndex]]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(185, 187, 223, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: const Color.fromRGBO(185, 187, 223, 1),
            icon: Image.asset(
              'lib/assets/icons/ic_time.png',
              width: 36,
              height: 36,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromRGBO(185, 187, 223, 1),
            icon: Image.asset(
              'lib/assets/icons/ic_add.png',
              width: 36,
              height: 36,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromRGBO(185, 187, 223, 1),
            icon: Image.asset(
              'lib/assets/icons/ic_book.png',
              width: 36,
              height: 36,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromRGBO(185, 187, 223, 1),
            icon: Image.asset(
              'lib/assets/icons/ic_profile.png',
              width: 36,
              height: 36,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}