import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'conversation_screen.dart';
import 'message_screen.dart';

class EklenenMesaj {
  final String userId;
  final String bookName;
  final String message;

  EklenenMesaj({
    required this.userId,
    required this.bookName,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookName': bookName,
      'message': message,
    };
  }
}

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  bool _isKVKKChecked = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _forumCollection =
  FirebaseFirestore.instance.collection('forums');
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;


  @override
  void dispose() {
    _bookTitleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<String?> _getUsername(String userId) async {
    final userDoc = await _usersCollection.doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>?;
    return userData?['username'];
  }

  Future<void> _addMessage() async {
    final userId = currentUserUid;
    final bookName = _bookTitleController.text;
    final message = _messageController.text;

    if (bookName.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm zorunlu alanları doldurun.'),
        ),
      );
      return;
    }

    final newMessage = EklenenMesaj(
      userId: userId,
      bookName: bookName,
      message: message,
    );
    await _forumCollection.add(newMessage.toMap());

    _bookTitleController.clear();
    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mesaj başarıyla eklendi.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Kitap Takası'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _forumCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final messageData =
              messages[index].data() as Map<String, dynamic>;
              final userId = messageData['userId'];
              final bookName = messageData['bookName'];
              final message = messageData['message'];

              return FutureBuilder<String?>(
                future: _getUsername(currentUserUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return ListTile(
                      title: Text('Kitap: $bookName'),
                      subtitle: Text('Kullanıcı adı: Yükleniyor...\nNot: $message'),
                      onTap: () {},
                    );
                  }

                  final username = snapshot.data ?? 'Bilinmeyen Kullanıcı';

                  return ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Kitap: $bookName'),
                    subtitle: Text('Kullanıcı adı: $username\nNot: $message'),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListPage(),
                          ),
                        );
                      },
                      child: Text('İletişime Geç'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Yeni Mesaj'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _bookTitleController,
                      decoration: InputDecoration(
                        labelText: 'Kitap İsmi',
                      ),
                    ),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Mesaj',
                      ),
                    ),
                    CheckboxListTile(
                      title: Text('KVKK Metnini Okudum ve Onaylıyorum'),
                      value: _isKVKKChecked,
                      onChanged: (value) {
                        setState(() {
                          _isKVKKChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('İptal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!_isKVKKChecked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('KVKK metnini onaylamadan mesaj oluşturamazsınız.'),
                          ),
                        );
                      } else {
                        _addMessage();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Oluştur'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}