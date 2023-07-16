import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_reminder/screens/library_screen.dart';
import 'package:read_reminder/screens/profile_screen.dart';
import 'package:read_reminder/screens/timer_screen.dart';

import '../screens/book_screen.dart';

class BottomNavigationBarPage extends StatefulWidget {
  final String titleOfBook;

  const BottomNavigationBarPage({Key? key, String? titleOfBook})
      : titleOfBook = titleOfBook ?? '';

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;
  late String bookTitle;
  late List<Widget> _widgetOptions;
  String? profileImageURL;
  String userId = '';
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    bookTitle = widget.titleOfBook;
    _widgetOptions = <Widget>[
      TimerPage(bookName: bookTitle),
      BookPage(),
      LibraryScreen(),
      ProfilePage(),
    ];
    _getCurrentUser();
    _getUserProfileImageURL();
  }

  void _updateProfileImageURL(String? imageURL) {
    setState(() {
      profileImageURL = imageURL;
    });
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
  }

  Future<void> _getUserProfileImageURL() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final imageURL = snapshot.docs[0]['profileImage'] as String?;
      _updateProfileImageURL(imageURL);
    }
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _previousIndex = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(185, 187, 223, 1),
              Color.fromRGBO(223, 244, 243, 1),
              Color.fromRGBO(185, 187, 223, 1),
            ],
          ),
        ),
        child:AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            var begin = Offset(_selectedIndex > _previousIndex ? 1.0 : -1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          child: _widgetOptions[_selectedIndex],
        ),
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
            icon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: profileImageURL == null || profileImageURL == ''
                    ? Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/f40-bootcamp-project.appspot.com/o/profile_images%2F1689352459687817.jpg?alt=media&token=5adc797a-d57a-4c20-ac54-23edc0c2121d',
                  width: 36,
                  height: 36,
                )
                    : Image.network(
                  profileImageURL!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }}
