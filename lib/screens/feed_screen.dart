import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:read_reminder/screens/notification_screen.dart';
import '../navigation/bottom_navigation_bar.dart';
import 'timer_screen.dart';

class FeedPage extends StatelessWidget {
  final String bookTitle;
  const FeedPage({super.key, String? bookTitle}) : bookTitle = bookTitle ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Consumer<CoinProvider>(
              builder: (context, coinProvider, _) {
                int coin = coinProvider.coin;

                return Text(
                  'Coin: $coin',
                  style: TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0)),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'lib/assets/icons/ic_coin.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifPage()),
            );
          },
          icon: Image.asset(
            'lib/assets/icons/ic_notif.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
      body: Container(
        child: BottomNavigationBarPage(titleOfBook: bookTitle),
      ),
    );
  }
}
