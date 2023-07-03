import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'feed_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool error = false;

  Future<void> _login() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FeedPage()));
      }
    } catch (e) {
      setState(() {
        error = true;
        _errorMessage = 'Giriş yaparken bir hata oluştu. E-postanızı veya '
            'şifrenizi kontrol ediniz!';
      });
      print(_errorMessage);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Google ile oturum açarken bir hata oluştu.';
      });
      print(_errorMessage);
    }
  }
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Color.fromRGBO(223, 244, 243, 1),
              Color.fromRGBO(218, 228, 238, 1),
              Color.fromRGBO(185, 187, 223, 1)],
            radius: 1.65,
            center: Alignment.topLeft,
          ),
        ),
        child: Flexible(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text('Giriş Yap', textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900,
                      fontSize: 32,
                      color: Color.fromRGBO(135, 142, 205, 1)),),
                Image.asset('lib/assets/aPngtreeahand_drawn_cute_cat_reading_4361091.png', width: 320, height: 230,),
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
                    decoration:
                    InputDecoration(labelText: 'E-posta', labelStyle: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,
                          vertical: 30),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
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
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(labelText: 'Şifre',
                      labelStyle: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,
                          vertical: 30),suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                if(error)
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.circleExclamation,
                          size: 15.0,
                          color: Color(0xFF878ECD),
                        ),
                        SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Color.fromRGBO(135, 142, 205, 1),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 10.0,),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(135, 142, 205, 1)),
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
                  onPressed: _login,

                  child: Text('Giriş Yap'),
                ),
                SizedBox(height: 8.0,),
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                }, child: Text('Şifremi Unuttum', style: TextStyle(fontSize:14 ,
                    color:Color.fromRGBO(135, 142, 205, 1),
                    fontWeight: FontWeight.bold ),)),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed:(){
                    _signInWithGoogle();
                    MaterialPageRoute(builder: (context) => FeedPage());
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 30.0,
                          color: Color.fromRGBO(235, 134, 134, 1),
                        ),
                        SizedBox(
                          width: 10,
                        ),

                        Text(
                          'Google ile devam et',
                          style:
                          TextStyle(color: Color.fromRGBO(255, 234, 220,1),fontWeight:FontWeight.bold,fontSize: 16),
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabın yok mu? Hemen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                    TextButton(
                      onPressed: _goToRegister,
                      child: Text('Kayıt Ol', style: TextStyle(color:Color.fromRGBO(135, 142, 205, 1),fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

