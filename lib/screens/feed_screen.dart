import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../navigation/bottom_navigation_bar.dart';
import 'login_screen.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // App bar'ı şeffaf yapar
        elevation: 0, // Gölgeyi kaldırır
        actions: [
          IconButton(
            onPressed: () {
              _signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.exit_to_app,color: Colors.black,),
          ),
          IconButton(
            onPressed: () {

            },
            icon: Image.asset('lib/assets/icons/ic_coin.png',width: 40,height: 40,),
          ),
        ],
        leading: IconButton( // Baş kısmına bildirim ikonu ekler
          onPressed: () {
            // Bildirim ikonuna tıklandığında yapılacak işlemler
          },
          icon: Image.asset('lib/assets/icons/ic_notif.png',width: 40,height: 40,),
        ),
      ),
      body: BottomNavigationBarPage(),
    );

  }
}
