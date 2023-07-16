import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:read_reminder/screens/feed_screen.dart';



class BookDetails extends StatelessWidget {
  late int index;

  BookDetails({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getBookDetails() async {
      var url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyDqYsnfMz5j3eo8kwp4leBxVNCR064m8As';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var items = data['items'];
        if (index >= 0 && index < items.length) {
          return items[index];
        } else {
          throw Exception('Invalid index');
        }
      } else {
        throw Exception(
            'API çağrısı başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(185, 187, 223, 1),
                Color.fromRGBO(223, 244, 243, 1),
                Color.fromRGBO(185, 187, 223, 1),
              ],

            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70,),
                const Text(
                  'Kitap Hakkında',
                  style: TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0), fontWeight: FontWeight.w700, fontSize: 24),
                ),
                const SizedBox(height: 40,),
                FutureBuilder<Map<String, dynamic>>(
                  future: getBookDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ SizedBox(
                            height: 100,
                          ),
                            CircularProgressIndicator(color: Color.fromRGBO(69, 74, 113, 1.0)  ,),
                            SizedBox(height: 16),
                            Text('Veriler Yükleniyor'),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var book = snapshot.data!;
                      var title = book['volumeInfo']['title'];
                      var author = book['volumeInfo']['authors'][0];
                      var description = book['volumeInfo']['description'] ?? 'Kitap Açıklaması Bulunamadı!';
                      var imageLinks = book['volumeInfo']['imageLinks'] != null
                          ? book['volumeInfo']['imageLinks']['smallThumbnail']
                          : 'https://placekitten.com/600/800';

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style:
                              const TextStyle(fontSize: 20, color: Color.fromRGBO(91, 93,
                                  140, 1.0), fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 18),
                            Image.network(imageLinks),
                            const SizedBox(height: 8),
                            Text(
                              'Yazar: $author',
                              style: const TextStyle(fontSize: 16, color: Color.fromRGBO(54, 56, 84, 1.0), fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              description,
                              style: const TextStyle(fontSize: 16, color: Color.fromRGBO(54, 56, 84, 1.0)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: const Text('Kitap kütüphaneye eklendi'),
                                        backgroundColor: const Color.fromRGBO(84, 90, 128, 1.0),
                                        duration: const Duration(seconds: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Geri al',
                                          textColor: const Color.fromRGBO(183, 220, 218, 1),
                                          onPressed: () {
                                            // Code to undo the action
                                          },
                                        ),
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 500), // Geçiş süresi
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                          return FeedPage(bookTitle: title); // İkinci sayfa widget'ını buraya yerleştirin
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text('Okumaya başla',style: TextStyle(color: Color.fromRGBO(
                                      13, 84, 84, 1.0),fontWeight: FontWeight.bold, fontSize: 18, shadows: [
                                    Shadow(
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                    ),
                                  ],),
                                  ),),
                                const Icon(FontAwesomeIcons.bookmark, color:Color.fromRGBO(
                                    13, 84, 84, 1.0), size: 16,shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                  ),
                                ],)
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text('Veri bulunamadı'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}