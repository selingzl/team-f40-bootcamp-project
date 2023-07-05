import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'lib/assets/background/bg_profile.png',
              ), // Kullanıcı resminin yolunu güncelleyin
            ),
            SizedBox(height: 16),
            Text(
              'Kullanıcı Adı',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            TextButton(
              onPressed: () {
                _signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.deepPurple,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
