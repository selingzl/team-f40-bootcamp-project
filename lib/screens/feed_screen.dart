import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_reminder/screens/notification_screen.dart';

import '../navigation/bottom_navigation_bar.dart';
import 'login_screen.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Text(
              '1923',
              style: GoogleFonts.amaranth(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'lib/assets/icons/ic_coin.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifPage()),
            );
          },
          icon: Image.asset(
            'lib/assets/icons/ic_notif.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BottomNavigationBarPage(),
      ),
    );
  }
}
