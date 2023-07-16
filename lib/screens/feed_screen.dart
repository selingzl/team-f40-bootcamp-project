import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:read_reminder/notification_demo_screen.dart';

import '../navigation/bottom_navigation_bar.dart';
import 'forum_screen.dart';
import 'message_screen.dart';
import 'timer_screen.dart';

class FeedPage extends StatelessWidget {
  final String bookTitle;

  const FeedPage({Key? key, String? bookTitle}) : bookTitle = bookTitle ?? '';

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
                                style: TextStyle(
                                    color: Color.fromRGBO(54, 56, 84, 1.0)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                FontAwesomeIcons.fire,
                                size: 15,
                                color: Color.fromRGBO(82, 87, 124, 1.0),
                              ),
                              SizedBox(
                                width: 15,
                              ),
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
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          // Geçiş süresi
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Geçiş animasyonunu özelleştirin
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end);
                            var curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            );

                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ForumPage(); // İkinci sayfa widget'ını buraya yerleştirin
                          },
                        ),
                      );
                    },
                    icon: Icon(
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
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500), // Geçiş süresi
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Geçiş animasyonunu özelleştirin
                          var begin = Offset(-1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end);
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return NotificationsScreen(); // İkinci sayfa widget'ını buraya yerleştirin
                        },
                      ),
                    );

                  },
                  icon: Icon(
                    FontAwesomeIcons.solidBell,
                    size: 18,
                    color: Color.fromRGBO(82, 87, 124, 1.0),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        // Geçiş süresi
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Geçiş animasyonunu özelleştirin
                          var begin = Offset(-1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end);
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return UserListPage(); // İkinci sayfa widget'ını buraya yerleştirin
                        },
                      ),
                    );
                  },
                  icon: Icon(
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
      body: Container(
        child: BottomNavigationBarPage(titleOfBook: bookTitle),
      ),
    );
  }
}
