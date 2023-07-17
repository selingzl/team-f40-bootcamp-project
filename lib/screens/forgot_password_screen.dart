import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
                'Şifre sıfırlama bağlantısı mail adresine gönderildi!'),
            title: const Text('Uyarı'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isEmailSent = true;
                  });
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
            title: const Text('Uyarı'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(218, 228, 238, 1),
              Color.fromRGBO(223, 244, 243, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20 * MediaQuery.of(context).size.height / 100 +
                  20, // 20 cm kadar aşağı indirildi
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: _goToLogin,
                  icon: const Icon(
                    FontAwesomeIcons.caretLeft,
                    color: Color.fromRGBO(135, 142, 205, 1),
                  ),
                ),
                const SizedBox(
                  width: 55,
                ),
                const Text(
                  'Şifre Sıfırlama',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      color: Color.fromRGBO(135, 142, 205, 1)),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Şifrenizi Sıfırlamak için E-Posta adresinizi girin!',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(135, 142, 205, 1),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-posta',
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(135, 142, 205, 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Image.asset(
                        'lib/assets/aPngtreeahand_drawn_cute_cat_reading_4361091.png',
                        height: 90,
                        width: 90,
                      ),
                      const SizedBox(height: 0.0),
                      ElevatedButton(
                        onPressed: resetPassword,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(135, 142, 205, 1),
                          ),
                          foregroundColor:
                          MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 40.0),
                          ),
                        ),
                        child: const Text('Şifremi Sıfırla'),
                      ),
                      if (_isEmailSent)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Şifre sıfırlama bağlantısı mail adresinize gönderildi!',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}