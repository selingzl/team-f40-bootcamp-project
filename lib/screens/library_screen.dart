import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:read_reminder/book_details.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _response = "";

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getBookList() async {
      var url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyAjQXgbDKufunEPUB4U_WrNifggfnvLt78';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var items = data['items'];
        return items;
      } else {
        throw Exception(
            'API çağrısı başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    }

    return Center(
      child: Scrollbar(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Text(
                  'Haftanın Kitap Önerileri',
                  style: TextStyle(color: Color.fromRGBO(69, 74, 113, 1.0), fontSize: 24, fontWeight: FontWeight.w700),
                ),
              SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.68,
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
    );
  }
}