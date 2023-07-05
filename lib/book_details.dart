import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookDetails extends StatelessWidget {
  late int index;

  BookDetails({required this.index});

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getBookDetails() async {
      var url =
          'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&langRestrict=tr&maxResults=30&&key=AIzaSyC4m3teesNWbfLMWZFxnNhbcSbV7GhaEMg';
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.star_border))],
        title: Center(
          child: Text(
            'Kitap Hakkında',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getBookDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
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
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Image.network(imageLinks),
                    SizedBox(height: 8),
                    Text(
                      'Yazar: $author',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {},
                            child: Text('Okundu olarak işaretle')),
                        SizedBox(
                          width: 5,
                        ),
                        OutlinedButton(
                            onPressed: () {}, child: Text('Bağış yap')),
                        SizedBox(
                          width: 5,
                        ),
                        OutlinedButton(
                            onPressed: () {}, child: Text('Okumaya Başla')),
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
      ),
    );
  }
}
