import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'timer_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(223, 244, 243, 1),
              Color.fromRGBO(218, 228, 238, 1),
              Color.fromRGBO(185, 187, 223, 1),
            ],
            radius: 1.65,
            center: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'lib/assets/background/bg_profile.png',
                  ), // Kullanıcı resminin yolunu güncelleyin
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Kullanıcı Adı',
                style: TextStyle(
                  color: Color.fromRGBO(54, 56, 84, 1.0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent
                    ),
                    child: Center(
                      child: Consumer<TimeProvider>(
                        builder: (context, timeProvider, _) {
                          int time = timeProvider.time;
                          return Text('Odaklanılan Süre\n$time saat',textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0), fontSize: 15,fontWeight: FontWeight.bold),);
                        },
                      ),
                    ),
                  ),
                  Icon(FontAwesomeIcons.clock, size:15, ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent // Arka plan rengi
                    ),

                    child: Center(
                      child: Text(
                        'Yapılan Bağışlar\n16', textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(54, 56, 84, 1.0), fontSize: 15,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Icon(FontAwesomeIcons.book, size:15, ),
                ],
              ),


              Container(
                height: 100,
                width: double.infinity,
                color: Color.fromRGBO(185, 187, 223, 1), // Arka plan rengi
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Text(
                    'Liste Sıralaması: 38',
                    style: TextStyle(
                        color: Color.fromRGBO(54, 56, 84, 1.0), fontSize: 18,fontWeight: FontWeight.bold
                    ),
                  ),
                ),
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
      ),
    );
  }
}