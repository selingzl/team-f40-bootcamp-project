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
          const Text(
            'Kitaplar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color.fromRGBO(82, 87, 124, 1.0),
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(const Color.fromRGBO(149, 157, 224, 1.0)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.16),
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
            child: const Icon(Icons.add, size: 20,),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                  ),
                  padding: const EdgeInsets.all(6),
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
      padding: const EdgeInsets.only(right: 5,left: 10,top: 2,bottom: 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.all(13),
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(185, 187, 223, 1),
                Color.fromRGBO(187, 198, 240, 1),
                Color.fromRGBO(183, 220, 218, 1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$spentTime dakika', textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(72, 86, 215, 1),
                    fontSize: 14,fontWeight: FontWeight.w600
                  ),
                ),

                const SizedBox(height: 10,),
                Text(
                  '$bookName',textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromRGBO(70, 75, 121, 1.0),
                      fontSize: 14, fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  '$comment', textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}