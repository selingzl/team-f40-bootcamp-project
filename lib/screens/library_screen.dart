import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:read_reminder/book_details.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _response = "";


  Random random = Random();

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getBookList() async {
      var url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyAjQXgbDKufunEPUB4U_WrNifggfnvLt78';
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

    int x = random.nextInt(30);

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.star,color: Color.fromRGBO(
                          98, 217, 217, 1.0),),
                      SizedBox(width: 14,),
                      Text('Hızlı Kitap Önerisi', style: TextStyle(
                          color: Color.fromRGBO(
                          98, 217, 217, 1.0), fontSize: 24, fontWeight: FontWeight.w700)),
                      SizedBox(width: 10,),
                      Icon(FontAwesomeIcons.star, color: Color.fromRGBO(
                          98, 217, 217, 1.0),),
                    ],
                  ),
                Container(
                  child: Text('randomBook'),
                ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.7,
              padding: EdgeInsets.all(10),
              child: Scrollbar(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Haftanın Kitap Önerileri',
                      style: TextStyle(color: Color.fromRGBO(69, 74, 113, 1.0), fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: FutureBuilder<List<dynamic>>(
                        future: getBookList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var bookList = snapshot.data;
                            return ListView.builder(
                              itemCount: bookList!.length,
                              itemBuilder: (context, index) {
                                var book = bookList[index];
                                var title = book['volumeInfo']['title'];
                                var subtitle = book['volumeInfo']['authors'][0] ?? 'Yazar bilgisi mevcut değil';
                                var imageLinks = book['volumeInfo']['imageLinks'] != null
                                    ? book['volumeInfo']['imageLinks']['smallThumbnail']
                                    : 'https://placekitten.com/600/800';

                                return ListTile(
                                  leading: IconButton(
                                    icon: const Icon(Icons.star_border),
                                    onPressed: () {},
                                  ),
                                  title: Text(
                                    title,
                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Color.fromRGBO(54, 56, 84, 1.0)),
                                  ),
                                  subtitle: Text(subtitle),
                                  trailing: Image.network(imageLinks),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BookDetails(
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
    );
  }
}

class Book {
  final String title;
  final String author;
  // Diğer kitap özelliklerini ekleyebilirsiniz

  Book(this.title, this.author);
}