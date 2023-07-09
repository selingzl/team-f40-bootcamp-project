import 'package:flutter/material.dart';

class donateListPage extends StatefulWidget {
  const donateListPage({super.key});

  @override
  State<donateListPage> createState() => _donateListPageState();
}

class _donateListPageState extends State<donateListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(185, 187, 223, 1),
              Color.fromRGBO(223, 244, 243, 1),
              Color.fromRGBO(185, 187, 223, 1),
            ],

          ),
        ),
      ),
    );
  }
}
