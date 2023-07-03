import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
            content: Text('Şifre sıfırlama bağlantısı mail adresine gönderildi!'),
            title: Text('Uyarı'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isEmailSent = true;
                  });
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
            title: Text('Uyarı'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Şifreni sıfırlamak için e-posta adresini gir'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(controller: _emailController),
          ),
          ElevatedButton(
            onPressed: () {
              resetPassword();
            },
            child: Text('Şifremi Sıfırla'),
          ),
          if (_isEmailSent)
            Text(
              'Şifre sıfırlama bağlantısı mail adresinize gönderildi!',
              style: TextStyle(color: Colors.green),
            ),
        ],
      ),
    );
  }
}
