import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:read_reminder/screens/book_details_screen.dart';
import '../model/book_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String userId = '';
  bool favButtonStatus = false;

  Random random = Random();

  final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favoriteBooks');

  List<Book> favoritesBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritesBooks();
  }

  Future<void> _loadFavoritesBooks() async {
    var favoritesList = await getFavoritesBooks();
    setState(() {
      favoritesBooks = favoritesList;
      if (favButtonStatus) {
        favButtonStatus = false;
      } else {
        favButtonStatus = true;
      }
    });
  }

  Future<void> addToFavorites(String title, String author) async {
    var userId = await _getCurrentUser();
    var bookName = '$title by $author';

    var isBookExist = await _checkIfBookExists(userId, bookName);
    if (!isBookExist) {
      await _favoritesCollection.add({
        'userId': userId,
        'bookName': bookName,
      });

      _loadFavoritesBooks();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Kitap favorilere eklendi'),
          backgroundColor: const Color.fromRGBO(84, 90, 128, 1.0),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          action: SnackBarAction(
            label: 'Geri al',
            textColor: const Color.fromRGBO(183, 220, 218, 1),
            onPressed: () {
              removeFromFavorites(title, author);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: const Text('Kitap favorilerden kaldırıldı'),
                  backgroundColor: const Color.fromRGBO(84, 90, 128, 1.0),
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Kitap favorilerde mevcut'),
          backgroundColor: const Color.fromRGBO(84, 90, 128, 1.0),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      );
    }
  }

  Future<void> removeFromFavorites(String title, String author) async {
    var userId = await _getCurrentUser();
    var bookName = '$title by $author';

    var querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('bookName', isEqualTo: bookName)
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }

    _loadFavoritesBooks();
  }

  Future<List<Book>> getFavoritesBooks() async {
    var userId = await _getCurrentUser();

    var querySnapshot =
        await _favoritesCollection.where('userId', isEqualTo: userId).get();

    var favoritesList = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        var bookName = data['bookName'];
        var title = bookName.split(' by ')[0];
        var author = bookName.split(' by ')[1];
        return Book(title, author);
      } else {
        throw Exception('Data is null or has an invalid format!!!');
      }
    }).toList();

    return favoritesList;
  }

  Future<String> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
    return userId;
  }

  Future<List<dynamic>> getBookList() async {
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyDqYsnfMz5j3eo8kwp4leBxVNCR064m8As';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var items = data['items'] as List<dynamic>;

      return items;
    } else {
      throw Exception(
          'API çağrısı başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }

  Future<bool> _checkIfBookExists(String userId, String bookName) async {
    var snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('bookName', isEqualTo: bookName)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  bool isBookInFavorites(String title, String author) {
    return favoritesBooks.contains(Book(title, author));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.star,
                        color:  Color.fromRGBO(149, 252, 244, 1.0),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        'Hızlı Kitap Önerisi',
                        style: TextStyle(
                          color:  Color.fromRGBO(140, 252, 250, 1.0),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        FontAwesomeIcons.star,
                        color:  Color.fromRGBO(149, 252, 244, 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: getBookList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var bookList = snapshot.data;
                        var randomBookIndex = random.nextInt(bookList!.length);
                        var randomBook = bookList[randomBookIndex];
                        var randomBookTitle = randomBook['volumeInfo']['title'];
                        var randomBookAuthor = randomBook['volumeInfo']
                                ['authors'][0] ??
                            'Yazar bilgisi mevcut değil';
                        var randomImageLinks =
                            randomBook['volumeInfo']['imageLinks'] != null
                                ? randomBook['volumeInfo']['imageLinks']
                                    ['smallThumbnail']
                                : 'https://placekitten.com/600/800';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 500), // Geçiş süresi
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  // Geçiş animasyonunu özelleştirin
                                  var begin = const Offset(1.0, 0.0);
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
                                  return BookDetails(
                                    index: randomBookIndex,
                                  );// İkinci sayfa widget'ını buraya yerleştirin
                                },
                              ),
                            );

                          },
                          child: Container(
                            height: 100,
                            width: 180,
                            padding: const EdgeInsets.all(10),
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Flexible(
                                        child: Text(
                                          randomBookTitle,
                                          style: const TextStyle(color :  Color.fromRGBO(
                                              150, 130, 185, 0.9921568627450981),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        randomBookAuthor,
                                        style: const TextStyle(color: Colors.black54,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.network(
                                  randomImageLinks,
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Scrollbar(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Haftanın Kitap Önerileri',
                        style: TextStyle(
                          color: Color.fromRGBO(69, 74, 113, 1.0),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: FutureBuilder<List<dynamic>>(
                          future: getBookList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var bookList = snapshot.data;
                              return GridView.builder(
                                itemCount: bookList!.length,
                                itemBuilder: (context, index) {
                                  var book = bookList[index];
                                  var title = book['volumeInfo']['title'];
                                  var subtitle = book['volumeInfo']['authors']
                                          [0] ??
                                      'Yazar bilgisi mevcut değil';
                                  var imageLinks =
                                      book['volumeInfo']['imageLinks'] != null
                                          ? book['volumeInfo']['imageLinks']
                                              ['smallThumbnail']
                                          : 'https://placekitten.com/600/800';
                                  bool check = isBookInFavorites(
                                      book['volumeInfo']['title'],
                                      book['volumeInfo']['authors'][0] ??
                                          'Yazar bilgisi mevcut değil');

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 500), // Geçiş süresi
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            // Geçiş animasyonunu özelleştirin
                                            var begin = const Offset(1.0, 0.0);
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
                                            return BookDetails(
                                              index: index,
                                            ); // İkinci sayfa widget'ını buraya yerleştirin
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        height: 90,
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
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: check
                                                      ? const Icon(
                                                          Icons.add,
                                                          size: 18,  color: Color.fromRGBO(
                                                      91, 73, 143, 1.0),
                                                        )
                                                      : const Icon(
                                                          Icons.add,
                                                          size: 18,  color:Color.fromRGBO(
                                                      91, 73, 143, 1.0),
                                                        ),
                                                  onPressed: () {
                                                    if (isBookInFavorites(
                                                        title, subtitle)) {
                                                      removeFromFavorites(
                                                          title, subtitle);
                                                    } else {
                                                      addToFavorites(
                                                          title, subtitle);
                                                    }
                                                  },
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    title,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(
                                                          54, 56, 84, 1.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              subtitle,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Flexible(
                                                child: Image.network(imageLinks)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Hata: ${snapshot.error}');
                            }
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Veriler Yükleniyor'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

