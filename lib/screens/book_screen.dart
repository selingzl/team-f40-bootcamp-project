import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<Widget> bookList = [];

  void bookAddition() {
    setState(() {
      bookList.add(
        Container(
          padding: const EdgeInsets.all(5),
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
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: TextStyle(
                    color: Color.fromRGBO(70, 75, 121, 1.0),
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Kitap ismi',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(69, 74, 113, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                Text(
                  'Okunan süre: ',
                  style: TextStyle(
                    color: Color.fromRGBO(72, 86, 215, 1),
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '0 saat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(72, 86, 215, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void libraryAddition() {

  }


  @override
  //book screen
  Widget build(BuildContext context) {
    return Center(
      child: Scrollbar(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60,),
              const Text(
                'Kitaplar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromRGBO(82, 87, 124, 1.0),
                ),
              ),
              IconButton(
                onPressed: () {
                  bookAddition();
                },
                icon: const Icon(
                  FontAwesomeIcons.plus,
                  color: Color.fromRGBO(82, 87, 124, 1.0),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height*0.58,

                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 15,
                  ),
                  padding: const EdgeInsets.all(6),
                  itemCount: bookList.length,
                  itemBuilder: (context, index) {
                    return bookList[index];
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