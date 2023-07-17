import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:read_reminder/screens/conversation_screen.dart';
import '../model/added_message_card_model.dart';
import 'kvkk_screen.dart';


class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

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
          backgroundColor: const Color.fromRGBO(183, 220, 218, 1),
          duration: const Duration(seconds: 2),
          content: const Text(
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

    final newMessage = AddedMessage(
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
        backgroundColor: const Color.fromRGBO(84, 90, 128, 1.0),
        duration: const Duration(seconds: 2),
        content: const Text('Kitap isteği başarıyla eklendi.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(183, 220, 218, 1),
        title: const Text(
          'Kitap Köprüsü',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(112, 118, 171, 1.0),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bg_welcomee.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 35, right: 15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kitap Ara...',
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(54, 56, 84, 1.0),
                  ),
                  prefixIcon: const Icon(
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
              child: StreamBuilder<QuerySnapshot>(
                stream: _forumCollection
                    .orderBy('likes', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Hata: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  List<Widget> cardWidgets = [];

                  for (var index = 0; index < messages.length; index++) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final messageId = messages[index].id;
                    final userId = messageData['userId'];
                    final bookName = messageData['bookName'];
                    final message = messageData['message'];
                    final likes = messageData['likes'];

                    if (_searchQuery.isEmpty ||
                        bookName.toLowerCase().contains(_searchQuery)) {
                      cardWidgets.add(FutureBuilder<String>(
                        future: getUsernameFromId(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Card(
                              color: const Color.fromRGBO(210, 241, 237, 1.0),
                              margin: const EdgeInsets.only(
                                right: 40,
                                left: 40,
                                bottom: 15,
                                top: 15,
                              ),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(196, 239, 237, 1.0),
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
                                    const Spacer(),
                                    const Icon(
                                      Icons.book_online,
                                      color: Color.fromRGBO(112, 118, 171, 1.0),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$bookName',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(54, 56, 84, 1.0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Detay:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color:
                                            Color.fromRGBO(112, 118, 171, 1.0),
                                      ),
                                    ),
                                    const Text(
                                      'yükleniyor...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Color.fromRGBO(88, 93, 141, 1.0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Kullanıcı adı:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color:
                                            Color.fromRGBO(127, 185, 183, 1.0),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Text(
                                      'Yükleniyor...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromRGBO(88, 145, 144, 1.0),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            );
                          }

                          final username =
                              snapshot.data ?? 'Bilinmeyen Kullanıcı';

                          return Card(

                            color: const Color.fromRGBO(210, 241, 237, 1.0),
                            margin: const EdgeInsets.only(
                              right: 30,
                              left: 30,
                              bottom: 5,
                              top: 5,
                            ),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(196, 239, 237, 1.0),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.bookOpenReader,
                                    color: Color.fromRGBO(112, 118, 171, 1.0),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$bookName',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromRGBO(73, 75, 121, 1.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color.fromRGBO(88, 93, 141, 1.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
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
                                    username,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(88, 145, 144, 1.0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _incrementLikes(messageId);
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              187, 198, 240, 1),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          minimumSize: const Size(100, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 4,
                                        ),
                                        icon: const Icon(
                                          Icons.thumb_up,
                                          color:
                                              Color.fromRGBO(88, 93, 141, 1.0),
                                        ),
                                      ),
                                      Text(
                                        '$likes',
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(88, 93, 141, 1.0),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              187, 198, 240, 1),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          minimumSize: const Size(100, 50),
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 4,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SendMessagePage(
                                                senderId: currentUserUid,
                                                receiverId: userId,
                                                recipientName: username,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('İletişime Geç'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(123, 133, 176, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromRGBO(196, 239, 237, 1.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                contentPadding: const EdgeInsets.only(top: 10.0),
                title: const Text('Yeni Bildiri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        right: 30,
                        left: 30,
                        bottom: 5,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _bookTitleController,
                        decoration: const InputDecoration(
                          labelText: 'Kitap İsmi',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 30,
                        left: 30,
                        bottom: 5,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Mesaj',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isKVKKChecked = !_isKVKKChecked;
                          });
                          if (_isKVKKChecked) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KvkkPage(),
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
                            color: _isKVKKChecked
                                ? Colors.green
                                : const Color.fromRGBO(123, 133, 176, 1.0),
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
                    child: const Text(
                      'İptal',
                      style: TextStyle(
                        color: Color.fromRGBO(133, 142, 185, 1.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(133, 142, 185, 1.0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                      minimumSize: const Size(70, 45),
                      textStyle: const TextStyle(
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
                            backgroundColor:
                                const Color.fromRGBO(183, 220, 218, 1),
                            duration: const Duration(seconds: 2),
                            content: const Text(
                              'KVKK metnini onaylamadan mesaj oluşturamazsınız.',
                            ),
                          ),
                        );
                      } else {
                        _addMessage();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Oluştur'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
