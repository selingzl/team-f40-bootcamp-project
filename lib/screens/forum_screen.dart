import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_reminder/screens/conversation_screen.dart';
import 'kvkk_screen.dart';

class EklenenMesaj {
  final String userId;
  final String bookName;
  final String message;
  final int likes;

  EklenenMesaj({
    required this.userId,
    required this.bookName,
    required this.message,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookName': bookName,
      'message': message,
      'likes': likes,
    };
  }
}

class ForumPage extends StatefulWidget {
  ForumPage({
    Key? key,
  }) : super(key: key);

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
  late String _searchQuery = '';

  @override
  void dispose() {
    _bookTitleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String userId = '';

  Future<String> _getCurrentUser(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return userId;
    }
    return '';
  }

  Future<String> getUsernameFromId(String userId) async {
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
      final username = userDoc.get('username');
      return username;
    } else {
      return 'Kullanıcı adı alınamadı!!!';
    }
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
          content: Text(
            'Lütfen tüm zorunlu alanları doldurun.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(112, 118, 171, 1.0),
            ),
          ),
        ),
      );
      return;
    }

    final newMessage = EklenenMesaj(
      userId: userId,
      bookName: bookName,
      message: message,
      likes: 0,
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

  Future<void> _incrementLikes(String messageId) async {
    final messageDoc =
    FirebaseFirestore.instance.collection('forums').doc(messageId);

    final messageSnapshot = await messageDoc.get();
    if (messageSnapshot.exists) {
      final currentLikes = messageSnapshot.get('likes') ?? 0;
      await messageDoc.update({'likes': currentLikes + 1});
    }
  }

  Widget _buildMessageCard(
      String userId,
      String bookName,
      String message,
      int likes,
      ) {
    return FutureBuilder<String>(
      future: getUsernameFromId(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Card(
            color: Color.fromRGBO(210, 241, 237, 1.0),
            margin: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 15,
            ),
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
                    color: Color.fromRGBO(112, 118, 171, 1.0),
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
                      color: Color.fromRGBO(54, 56, 84, 1.0),
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
                      color: Color.fromRGBO(112, 118, 171, 1.0),
                    ),
                  ),
                  Text(
                    'yükleniyor...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color.fromRGBO(88, 93, 141, 1.0),
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
                      color: Color.fromRGBO(127, 185, 183, 1.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'yükleniyor...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(88, 145, 144, 1.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        }

        final username = snapshot.data ?? 'Bilinmeyen Kullanıcı';

        return Card(
          color: Color.fromRGBO(210, 241, 237, 1.0),
          margin: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 15,
          ),
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
                  color: Color.fromRGBO(112, 118, 171, 1.0),
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
                    color: Color.fromRGBO(54, 56, 84, 1.0),
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
                    color: Color.fromRGBO(112, 118, 171, 1.0),
                  ),
                ),
                Text(
                  '$message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color.fromRGBO(88, 93, 141, 1.0),
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
                    color: Color.fromRGBO(127, 185, 183, 1.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$username',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(88, 145, 144, 1.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _incrementLikes(userId);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Color.fromRGBO(187, 198, 240, 1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.thumb_up),
                    ),
                    Text('$likes'),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(187, 198, 240, 1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        minimumSize: Size(100, 50),
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendMessagePage(
                              senderId: currentUserUid,
                              receiverId: userId,
                              recipientName: username,
                            ),
                          ),
                        );
                      },
                      child: Text('İletişime Geç'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> messages) {
    return GridView.count(
      crossAxisCount: 1,
      children: messages.map((message) {
        final messageData = message.data() as Map<String, dynamic>;
        final messageId = message.id;
        final userId = messageData['userId'];
        final bookName = messageData['bookName'];
        final messageText = messageData['message'];
        final likes = messageData['likes'];

        if (_searchQuery.isEmpty ||
            bookName.toLowerCase().contains(_searchQuery)) {
          return _buildMessageCard(userId, bookName, messageText, likes);
        } else {
          return SizedBox.shrink();
        }
      }).toList(),
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
            color: Color.fromRGBO(112, 118, 171, 1.0),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Ekran Resmi 2023-07-16 19.49.32.png'),
            fit: BoxFit.cover,
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
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(54, 56, 84, 1.0),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromRGBO(178, 142, 245, 1.0),
                  ),
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

                    final filteredMessages = messages.where((message) {
                      final messageData = message.data() as Map<String, dynamic>;
                      final bookName = messageData['bookName'];
                      return _searchQuery.isEmpty ||
                          bookName.toLowerCase().contains(_searchQuery);
                    }).toList();

                    return _buildGridView(filteredMessages);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(123, 133, 176, 1.0),
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
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                contentPadding: EdgeInsets.only(top: 10.0),
                title: Text('Yeni Bildiri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        bottom: 5,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _bookTitleController,
                        decoration: InputDecoration(
                          labelText: 'Kitap İsmi',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        bottom: 5,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Mesaj',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isKVKKChecked = !_isKVKKChecked;
                          });
                          if (_isKVKKChecked) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KvkkPage(),
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: _isKVKKChecked
                                ? Colors.green
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          'KVKK Metnini Okudum ve Onaylıyorum',
                          style: TextStyle(
                            color: _isKVKKChecked ? Colors.green : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'İptal',
                      style: TextStyle(
                        color: Color.fromRGBO(133, 142, 185, 1.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(133, 142, 185, 1.0),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      minimumSize: Size(70, 45),
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
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
                              'KVKK metnini onaylamadan mesaj oluşturamazsınız.',
                            ),
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
