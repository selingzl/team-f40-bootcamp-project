import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  late String _searchQuery = '';

  @override
  void dispose() {
    _bookTitleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<String> getUserName(String userId) async {
    // Kullanıcının adını almak için gerekli işlemleri gerçekleştirin
    // Örneğin, Firestore'dan kullanıcı belgelerini sorgulayabilirsiniz.
    // Bu işlev, userId temelinde kullanıcı adını döndürmelidir.
    // Örneğin:
    // final userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // final username = userData['username'];
    // return username;

    // Geçici olarak kullanıcı adını 'Bilinmeyen Kullanıcı' olarak döndürüyoruz
    return 'Bilinmeyen Kullanıcı';
  }

  Future<void> _addMessage() async {
    final userId = currentUserUid;
    final bookName = _bookTitleController.text;
    final message = _messageController.text;

    if (bookName.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromRGBO(183, 220, 218, 1),
          duration: const Duration(seconds: 2),
          content: Text('Lütfen tüm zorunlu alanları doldurun.',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(112, 118, 171, 1.0)),
          ),
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Color.fromRGBO(84, 90, 128, 1.0),
        duration: const Duration(seconds: 2),
        content: Text('Kitap isteği başarıyla eklendi.'),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(183, 220, 218, 1),
        title: Text(
          'Kitap Köprüsü',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(112, 118, 171, 1.0)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(183, 220, 218, 1),
              Color.fromRGBO(187, 198, 240, 1),
              Color.fromRGBO(185, 187, 223, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kitap Ara...',
                  labelStyle: TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0),),
                  prefixIcon: Icon(Icons.search, color: Color.fromRGBO(
                      178, 142, 245, 1.0),),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _forumCollection.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final messages = snapshot.data!.docs;

                    List<Widget> cardWidgets = [];

                    for (var index = 0; index < messages.length; index++) {
                      final messageData =
                          messages[index].data() as Map<String, dynamic>;
                      final userId = messageData['userId'];
                      final bookName = messageData['bookName'];
                      final message = messageData['message'];

                      if (_searchQuery.isEmpty ||
                          bookName.toLowerCase().contains(_searchQuery)) {
                        cardWidgets.add(FutureBuilder<String>(
                          future: getUserName(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Card(
                                color: Color.fromRGBO(210, 241, 237, 1.0),
                                margin: EdgeInsets.only(
                                    right: 40, left: 40, bottom: 15, top: 15),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(196, 239, 237, 1.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Icon(
                                          Icons.account_circle,
                                          color:
                                          Color.fromRGBO(112, 118, 171, 1.0),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '$bookName',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color:
                                            Color.fromRGBO(54, 56, 84, 1.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Detay:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Color.fromRGBO(
                                                112, 118, 171, 1.0),
                                          ),
                                        ),
                                        Text(
                                          'yükleniyor...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color:
                                            Color.fromRGBO(88, 93, 141, 1.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Kullanıcı adı:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              color: Color.fromRGBO(
                                                  127, 185, 183, 1.0),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'yükleniyor...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromRGBO(
                                                  88, 145, 144, 1.0),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                  ]),
                                ),
                              );
                            }

                            final username =
                                snapshot.data ?? 'Bilinmeyen Kullanıcı';

                            return Card(
                              color: Color.fromRGBO(210, 241, 237, 1.0),
                              margin: EdgeInsets.only(
                                  right: 40, left: 40, bottom: 15, top: 15),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(196, 239, 237, 1.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.account_circle,
                                        color:
                                            Color.fromRGBO(112, 118, 171, 1.0),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '$bookName',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Color.fromRGBO(54, 56, 84, 1.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Detay:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromRGBO(
                                              112, 118, 171, 1.0),
                                        ),
                                      ),
                                      Text(
                                        '$message',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color:
                                              Color.fromRGBO(88, 93, 141, 1.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Kullanıcı adı:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Color.fromRGBO(
                                                127, 185, 183, 1.0),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '$username',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                88, 145, 144, 1.0),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(
                                                187, 198, 240, 1),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            minimumSize: Size(100, 50),
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 4),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              // Geçiş süresi
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                // Geçiş animasyonunu özelleştirin
                                                var begin = Offset(1.0, 0.0);
                                                var end = Offset.zero;
                                                var curve = Curves.ease;

                                                var tween = Tween(
                                                    begin: begin, end: end);
                                                var curvedAnimation =
                                                    CurvedAnimation(
                                                  parent: animation,
                                                  curve: curve,
                                                );

                                                return SlideTransition(
                                                  position: tween
                                                      .animate(curvedAnimation),
                                                  child: child,
                                                );
                                              },
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return UserListPage(); // İkinci sayfa widget'ını buraya yerleştirin
                                              },
                                            ),
                                          );
                                        },
                                        child: Text('İletişime Geç'),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ]),
                              ),
                            );
                          },
                        ));
                      }
                    }

                    return GridView.count(
                      crossAxisCount: 1,
                      children: cardWidgets,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(
            123, 133, 176, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
    ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromRGBO(196, 239, 237, 1.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                title: Text('Yeni Bildiri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 30,left: 30,bottom: 5,top: 10),
                      child: TextFormField(
                        controller: _bookTitleController,
                        decoration: InputDecoration(
                          labelText: 'Kitap İsmi',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 30,left: 30,bottom: 5,top: 10),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Mesaj',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: CheckboxListTile(
                        title: Text('KVKK Metnini Okudum ve Onaylıyorum'),
                        value: _isKVKKChecked,
                        onChanged: (value) {
                          setState(() {
                            _isKVKKChecked = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('İptal', style: TextStyle(color: Color.fromRGBO(
                        133, 142, 185, 1.0),),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(
                            133, 142, 185, 1.0),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(70, 45),
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),
                        elevation: 4),
                    onPressed: () {
                      if (!_isKVKKChecked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: Color.fromRGBO(183, 220, 218, 1),
                            duration: const Duration(seconds: 2),
                            content: Text(
                                'KVKK metnini onaylamadan mesaj oluşturamazsınız.'),
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
