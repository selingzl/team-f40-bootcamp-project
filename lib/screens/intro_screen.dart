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
      'title': 'Hoş Geldin!',
      'description': 'Uyandığıma göre sana buraları tanıtabilirim :3',
      'image': 'lib/assets/giriş.png',
    },
    {
      'title': 'Okurken Kronometre ve Zamanlayıcı Tutabilirsin',
      'description': 'Kitap okumayı daha verimli hale getirebilirsin. Kitap okudukça coin kazan ve bu coinlerle kitap bağışında bulunmayı unutma!',
      'image': 'lib/assets/timerfront.png',
    },
    {
      'title': 'Kütüphane ile Yeni Kitaplar Keşfet!',
      'description': 'Hızlı ve haftalık kitap önerilerini kullanırsan kendin için keyifli ve faydalı kitapları bulabilirsin.',
      'image': 'lib/assets/Firefly a library has colors of DFF4F3 and B9BBDF and a cute cat who holds a book 25387.png',
    },
    {
      'title': 'Kitap Köprüsü ile Aradığın Kitaplara Ulaş',
      'description':
          'Artık aradığın ender kitaba sahip olmak bir mesaj uzağında!',
      'image': 'lib/assets/Firefly a bridge which made of books and a super cute orange cat near it 86126.png',
    },
    {
      'title': 'Hadi Okumaya Başlayalım :3',
      'description': 'Kitap okumanın en keyifli hali için ReadMe!',
      'image': 'lib/assets/Firefly a library has colors of DFF4F3 and B9BBDF and an orange cute happy cat who holds a book 4012.png',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Ekran Resmi 2023-07-16 19.49.32.png'),
            fit: BoxFit.cover,
          ),
          ),

        child: Stack(
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(82, 87, 124, 1.0),
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            data['description']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(82, 87, 124, 1.0),
              fontStyle: FontStyle.italic,
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
        color: _currentPage == index
            ? const Color.fromRGBO(135, 142, 205, 1)
            : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
