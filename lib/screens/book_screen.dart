import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late TextEditingController _controller;
  late TextEditingController _controllerB;
  late TextEditingController _controllerC;
  String userId = '';
  List<Widget> bookList = [];

  @override
  void initState() {
    _controller = TextEditingController();
    _controllerB = TextEditingController();
    _controllerC = TextEditingController();
    _getCurrentUser();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerB.dispose();
    _controllerC.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
  }

  void bookAddition(String bookName, int spentTime, String comment) {
    _addBookToFirestore(bookName, spentTime,comment);
  }

  final CollectionReference _usersBookCollection =
  FirebaseFirestore.instance.collection('userBooks');

  Future<void> _addBookToFirestore(String bookName, int spentTime,String comment) async {
    await _usersBookCollection.add({
      'userId': userId,
      'bookName': bookName,
      'spentTime': spentTime,
      'comment': comment
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(const Color.fromRGBO(135, 142, 205, 1)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(51.16),
                  ),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Kitap Ekle',style: TextStyle(color: Color.fromRGBO(135, 142, 205, 1)),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Kitap İsmi',
                          ),
                        ),
                        TextField(
                          controller: _controllerB,
                          decoration: const InputDecoration(
                            labelText: 'Harcanan Süre (dakika)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: _controllerC,
                          decoration: const InputDecoration(
                            labelText: 'Notunuz',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(const Color.fromRGBO(135, 142, 205, 1)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 9.0, horizontal: 15.0),
                          ),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(51.16),
                            ),
                          ),
                        ),

                        onPressed: () {
                          final bookName = _controller.text.trim();
                          final spentTimeText = _controllerB.text.trim();
                          final comment = _controllerC.text.trim();
                          int spentTime = 0;

                          if (spentTimeText.isNotEmpty) {
                            spentTime = int.tryParse(spentTimeText) ?? 0;
                          }

                          if (bookName.isNotEmpty && spentTime != 0) {
                            bookAddition(bookName, spentTime,comment);
                            _controllerB.clear();
                            _controller.clear();
                            _controllerC.clear();
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Ekle'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('İptal',style: TextStyle(color: Color.fromRGBO(135, 142, 205, 1)),),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersBookCollection
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('Veriler Yükleniyor'),
                      ],
                    ),
                  );
                }

                final documents = snapshot.data!.docs;

                return GridView.builder(

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final userId = documents[index].get('userId');
                    final bookName = documents[index].get('bookName');
                    final spentTime = documents[index].get('spentTime');
                    final comment = documents[index].get('comment');

                    return UserBookCard(
                      userId: userId,
                      bookName: bookName,
                      spentTime: spentTime,
                      comment: comment,
                      controller: _controller,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserBookCard extends StatelessWidget {
  final String userId;
  final String bookName;
  final int spentTime;
  final String comment;
  final TextEditingController controller;

  const UserBookCard({
    required this.userId,
    required this.bookName,
    required this.spentTime,
    required this.comment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: Color.fromRGBO(185, 187, 223, 1),
            width: 1.0,
          ),
        ),
        color: const Color.fromRGBO(185, 187, 223, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kitap İsmi : $bookName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color.fromRGBO(82, 87, 124, 1.0),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'Süre: $spentTime dakika',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color.fromRGBO(82, 87, 124, 1.0),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'Notum: $comment',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color.fromRGBO(82, 87, 124, 1.0),
                ),
              ),
              // TextField(
              // controller: controller,
              //),
            ],
          ),
        ),
      ),
    );
  }
}
