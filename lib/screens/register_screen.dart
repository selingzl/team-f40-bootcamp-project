import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Kayıt olurken bir hata oluştu: $e';
      });
      print(_errorMessage);
    }
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
<<<<<<< HEAD
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
=======
      padding: EdgeInsets.all(50),
>>>>>>> 1d1104e (şifremi unuttum ekran tasarımı yapıldı.)
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color.fromRGBO(185, 187, 223, 1),
            Color.fromRGBO(218, 228, 238, 1),
            Color.fromRGBO(223, 244, 243, 1),
          ],
          radius: 1.65,
          center: Alignment.topLeft,
        ),
      ),
      child: Flexible(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _goToLogin,
                    icon: Icon(FontAwesomeIcons.caretLeft),
                    color: Color.fromRGBO(135, 142, 205, 1),
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  Text(
                    'Kayıt Ol',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Color.fromRGBO(135, 142, 205, 1)),
                  ),
                ],
              ),
              SizedBox(
<<<<<<< HEAD
                height: 50,
=======
                height: 150,
>>>>>>> 1d1104e (şifremi unuttum ekran tasarımı yapıldı.)
              ),
              Container(
                height: 68,
                width: 320,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.0,
                      blurRadius: 1.0,
                      offset: Offset(0, 3), // horizontal, vertical offset
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TextFormField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 68,
                width: 320,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.0,
                      blurRadius: 1.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Column(
                children: [
                  Image.asset(
                    'lib/assets/aPngtreeahand_drawn_cute_cat_reading_4361091.png',
                    height: 90,
                    width: 90,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(135, 142, 205, 1)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 40.0),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(51.16),
                        ),
                      ),
                    ),
                    onPressed: _register,
                    child: Text('Kayıt Ol'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
