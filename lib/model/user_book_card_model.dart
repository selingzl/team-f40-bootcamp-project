import 'package:flutter/material.dart';
import '../screens/feed_screen.dart';

class UserBookCard extends StatefulWidget {
  final String bookId;
  final String bookName;
  final int spentTime;
  final String comment;
  final Function(String, String, int, String) onUpdate;

  const UserBookCard({super.key,
    required this.bookId,
    required this.bookName,
    required this.spentTime,
    required this.comment,
    required this.onUpdate,
  });

  @override
  _UserBookCardState createState() => _UserBookCardState();
}

class _UserBookCardState extends State<UserBookCard> {
  late String updatedBookName;
  late int updatedSpentTime;
  late String updatedComment;

  @override
  void initState() {
    updatedBookName = widget.bookName;
    updatedSpentTime = widget.spentTime;
    updatedComment = widget.comment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            title: const Text('Kitap Düzenle',
                style: TextStyle(color: Color.fromRGBO(135, 142, 205, 1))),
            content: Container(
              width: 300,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        updatedBookName = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: const OutlineInputBorder(),
                      labelText: 'Kitap İsmi',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(82, 87, 124, 1.0),
                      ),
                      hintText: updatedBookName,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        updatedSpentTime = int.tryParse(value) ?? 0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: const OutlineInputBorder(),
                      labelText: 'Harcanan Zaman',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(82, 87, 124, 1.0),
                      ),
                      hintText: updatedSpentTime.toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(82, 87, 124, 1.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        updatedComment = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: const OutlineInputBorder(),
                      labelText: 'Notunuz',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(82, 87, 124, 1.0),
                      ),
                      hintText: updatedComment,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(135, 142, 205, 1)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 9.0, horizontal: 15.0),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(51.16),
                    ),
                  ),
                ),
                onPressed: () {
                  widget.onUpdate(widget.bookId, updatedBookName,
                      updatedSpentTime, updatedComment);
                  Navigator.pop(context);
                },
                child: const Text('Kaydet'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'İptal',
                    style: TextStyle(
                      color: Color.fromRGBO(82, 87, 124, 1.0),
                    ),
                  )),
            ],
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
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
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(183, 220, 218, 1),
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      minimumSize: const Size(40, 20),
                      maximumSize: const Size(50, 30),
                      textStyle:
                      const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        // Geçiş süresi
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Geçiş animasyonunu özelleştirin
                          var begin = const Offset(0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end);
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FeedPage(
                              bookTitle:
                              updatedBookName);
                        },
                      ),
                    );
                  },
                  child: const Text('oku'),
                ),
                Text(
                  '${widget.spentTime} dakika',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(72, 86, 215, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.bookName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(70, 75, 121, 1.0),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.comment,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color.fromRGBO(82, 87, 124, 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}