import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  final String userName;
  final String email;

  const RegisterPage({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _passwordVisible = false;
  String _errorMessage = '';

  Future<void> _register() async {
    try {
      if (await checkUsernameExists(_userNameController.text.trim())) {
        print('true');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Username Exists'),
              content: const Text(
                  'The username already exists. Please choose a different username.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

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
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
        );
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
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<bool> checkUsernameExists(String username) async {
    bool exists = false;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      exists = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username existence: $e');
    }

    return exists;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUser() {
      return users
          .add({
        'username': _userNameController.text,
        'currentPoint': 0,
        'lastReadDate': DateTime.now(),
        'profileImage': '',
        'totalTime': 0,
        'userId': _auth.currentUser!.uid,
        'donationCount': 0
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      body: Center(
        child: Container(
          height: 1400,
          width: 600,
          padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    IconButton(
                      onPressed: _goToLogin,
                      icon: const Icon(FontAwesomeIcons.caretLeft),
                      color: const Color.fromRGBO(135, 142, 205, 1),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kayıt Ol',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Color.fromRGBO(135, 142, 205, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  height: 68,
                  width: 320,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.0,
                        blurRadius: 1.0,
                        offset: const Offset(0, 3), // horizontal, vertical offset
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: 'İsim',
                      labelStyle:
                      TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 68,
                  width: 320,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.0,
                        blurRadius: 1.0,
                        offset: const Offset(0, 3), // horizontal, vertical offset
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      labelStyle:
                      TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 68,
                  width: 320,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.0,
                        blurRadius: 1.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(170, 170, 170, 1)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      suffixIcon: IconButton(
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                            const Color.fromRGBO(135, 142, 205, 1)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 40.0),
                        ),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(51.16),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await _register();
                        addUser();
                      },
                      child: const Text('Kayıt Ol'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}