import 'package:flutter/material.dart';

import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {
      'title': 'Hoş Geldiniz!',
      'description': 'Odaklan...',
      'image': 'lib/assets/background/bg_profile.png',
    },
    {
      'title': 'Özellikleri Keşfedin',
      'description': 'Kitap okumayı daha verimli hale getirin.',
      'image': 'lib/assets/background/bg_profile.png',
    },
    {
      'title': 'Başlayalım!',
      'description': 'Uygulamayı kullanmaya başlamak için hazırız.',
      'image': 'lib/assets/background/bg_profile.png',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _introData.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return buildIntroPage(_introData[index]);
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
      floatingActionButton: _currentPage == _introData.length - 1
          ? FloatingActionButton(
              backgroundColor: const Color.fromRGBO(135, 142, 205, 1),
              onPressed: _navigateToNextScreen,
              child: Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  Widget buildIntroPage(Map<String, String> data) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data['image']!,
            height: 200.0,
          ),
          SizedBox(height: 30.0),
          Text(
            data['title']!,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            data['description']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _introData.length; i++) {
      indicators.add(_buildPageIndicatorItem(i));
    }
    return indicators;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: _currentPage == index ? 16.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color.fromRGBO(135, 142, 205, 1) : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
