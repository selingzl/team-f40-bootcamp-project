import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class TimerPage extends StatefulWidget {
  final String bookName;

  const TimerPage({super.key, String? bookName}) : bookName = bookName ?? '';

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = _animationController.drive(
      CurveTween(curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userId;
    if (user != null) {
      userId = user!.uid;
    }

    CollectionReference userBooksCollection =
        FirebaseFirestore.instance.collection('userBooks');

    Future<void> addUser() {
      return userBooksCollection
          .add({
            'bookName': widget.bookName,
            'comment': '',
            'spentTime': 2, //2 yerine timer durduruldugunda alinan sure gelecek
            'userId': userId
          })
          .then((value) => print('User added successfully'))
          .catchError((error) => print('Failed to add user: $error'));
    }

    Future<void> updateUser(DocumentSnapshot bookDoc) {
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
      int oldSpentTimeVal = bookData['spentTime'];
      int updatedSpentTime = oldSpentTimeVal +
          2; //2 yerine timer durduruldugunda alinan sure gelecek...

      DocumentReference userBookDocRef = bookDoc.reference;
      return userBookDocRef
          .update({'spentTime': updatedSpentTime})
          .then((value) => print('userBook data is updated successfully'))
          .catchError(
              (error) => print('Failed to update userBook data: $error'));
    }

    //Bu metodu timer durduruldugunda cagirman gerekiyor. Boylece login olan kullanici icin mevcut olarak okunan kitapla ilgili
    //Firestore'da kayit varsa, bu kayittaki kitap icin okunan sure guncellenir veya bununla ilgili yeni kayit eklenir.
    Future<void> addOrUpdateUserBook() async {
      QuerySnapshot querySnapshot = await userBooksCollection
          .where('userId', isEqualTo: userId)
          .where('bookName', isEqualTo: 'your_book_name')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot bookDocument = querySnapshot.docs.first;
        await updateUser(bookDocument);
      } else {
        // User record doesn't exist, add a new record
        await addUser();
      }
    }

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromRGBO(223, 244, 243, 1),
                Color.fromRGBO(218, 228, 238, 1),
                Color.fromRGBO(185, 187, 223, 1)
              ],
              radius: 1.65,
              center: Alignment.topLeft,
            ),
          ),
          child: Stack(children: [
            //Text(widget.bookName),

            Image.asset(
              'lib/assets/timer.png',
              width: 200,
              height: 200,
            ),
          ]),
        ),
      ),
    );
  }
}
