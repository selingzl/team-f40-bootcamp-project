import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteBooksScreen extends StatefulWidget {
  @override
  State<FavoriteBooksScreen> createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favoriteBooks')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Veri Yok'),
            );
          } else {
            final books = snapshot.data!.docs;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final bookName =
                (books[index].data() as Map<String, dynamic>)['bookName'];
                return ListTile(
                  trailing: TextButton(
                    onPressed: (){},
                    child: Text('Sil'),
                  ),
                  title: Text(bookName),
                );
              },
            );
          }
        },
      ),
    );
  }
}
