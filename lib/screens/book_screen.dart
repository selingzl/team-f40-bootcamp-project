import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  //book screen
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),

        child: Scrollbar(
          child: ListView(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Kitaplar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color.fromRGBO(
                      82, 87, 124, 1.0),),),
                ],
              ),
              const SizedBox(height: 65,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                      Color.fromRGBO(185, 187, 223,1),
                      Color.fromRGBO(187, 198, 240, 1),
                      Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                        ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                      labelText: 'Kitap ismi',
                      labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                          , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 90,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                        Color.fromRGBO(185, 187, 223,1),
                        Color.fromRGBO(187, 198, 240, 1),
                        Color.fromRGBO(183, 220, 218, 1)]), boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),)]
                      ,borderRadius: BorderRadius.circular(30.00),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField( style: TextStyle(color: Color.fromRGBO(
                              70, 75, 121, 1.0),fontSize: 15),decoration: InputDecoration(
                            labelText: 'Kitap ismi',
                            labelStyle: TextStyle(color:Color.fromRGBO(69, 74, 113, 1), fontSize: 14, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)
                            , border: InputBorder.none,),),

                          Text('Okunan süre: ', style: TextStyle(color:Color.fromRGBO(72, 86, 215, 1),fontSize: 11),),
                          SizedBox(height: 5,),
                          Text('0 saat',style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color:Color.fromRGBO(72, 86, 215, 1),),),
                          SizedBox(height: 2,),
                          TextField(style: TextStyle(fontSize: 10,color: Color.fromRGBO(64, 64, 64, 1)),decoration: InputDecoration(labelText:'Not: ', labelStyle: TextStyle(fontSize: 12,color: Color.fromRGBO(64, 64, 64, 1)), border: InputBorder.none,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ] ),
        ),

        
        
      ),
    );
  }
}
