import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:read_reminder/screens/notification_demo_screen.dart';
import '../navigation/bottom_navigation_bar.dart';
import '../provider/coin_provider.dart';
import 'forum_screen.dart';
import 'message_screen.dart';

class FeedPage extends StatelessWidget {
  final String bookTitle;
  const FeedPage({super.key,String? bookTitle}) : bookTitle = bookTitle ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Consumer<CoinProvider>(
                        builder: (context, coinProvider, _) {
                          int coin = coinProvider.coin;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Coin: $coin',
                                style: const TextStyle(color: Color.fromRGBO(54, 56, 84, 1.0)),
                              ),
                              const SizedBox(width: 5,),
                              const Icon(
                                FontAwesomeIcons.fire,
                                size: 15,
                                color: Color.fromRGBO(82, 87, 124, 1.0),
                              ),
                              const SizedBox(width: 15,),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForumPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.library_books,
                      size: 20,
                      color: Color.fromRGBO(82, 87, 124, 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        leading: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen()),
                    );
                  },
                  icon: const Icon(
                    FontAwesomeIcons.solidBell,
                    size: 18,
                    color: Color.fromRGBO(82, 87, 124, 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserListPage()),
                    );
                  },
                  icon: const Icon(
                    FontAwesomeIcons.message,
                    size: 18,
                    color: Color.fromRGBO(82, 87, 124, 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BottomNavigationBarPage(titleOfBook: bookTitle),
    );
  }
}