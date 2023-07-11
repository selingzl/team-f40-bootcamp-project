import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:read_reminder/screens/feed_screen.dart';
import 'package:read_reminder/screens/library_screen.dart';
import 'package:read_reminder/screens/timer_screen.dart';


class BookDetails extends StatelessWidget {
  late int index;

  BookDetails({required this.index});

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getBookDetails() async {
      var url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyAjQXgbDKufunEPUB4U_WrNifggfnvLt78';
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
      body: Scrollbar(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
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
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      IconButton(onPressed:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LibraryScreen()),
                        );
                      }, icon: Icon(FontAwesomeIcons.backward, color: Color.fromRGBO(54, 56, 84, 1.0),)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Kitap Hakkında',
                    style: TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0), fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  SizedBox(height: 40,),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getBookDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ SizedBox(
                              height: 100,
                            ),
                              CircularProgressIndicator(),
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
                        var description = book['volumeInfo']['description'] != null
                            ? book['volumeInfo']['description']
                            : 'Kitap Açıklaması Bulunamadı!';
                        var imageLinks = book['volumeInfo']['imageLinks'] != null
                            ? book['volumeInfo']['imageLinks']['smallThumbnail']
                            : 'https://placekitten.com/600/800';

                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style:
                                    TextStyle(fontSize: 20, color: Color.fromRGBO(91, 93,
                                        140, 1.0), fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 18),
                              Image.network(imageLinks),
                              SizedBox(height: 8),
                              Text(
                                'Yazar: $author',
                                style: TextStyle(fontSize: 16, color: Color.fromRGBO(54, 56, 84, 1.0), fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 30),
                              Text(
                                description,
                                style: TextStyle(fontSize: 16, color: Color.fromRGBO(54, 56, 84, 1.0)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {},
                                      child: Text('Okundu olarak işaretle', style: TextStyle(color: Color.fromRGBO(
                                      54, 56, 84, 1.0), fontWeight: FontWeight.bold),)),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  OutlinedButton(
                                      onPressed: () {
                                        /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TimerPage(bookName: title)),
                                        );*/
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FeedPage(bookTitle: title)));
                                      },
                                      child: Text('Oku', style: TextStyle(color: Color.fromRGBO(
                                          54, 56, 84, 1.0), fontWeight: FontWeight.bold),)),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Center(child: Text('Veri bulunamadı'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}