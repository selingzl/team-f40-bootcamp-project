import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:read_reminder/screens/feed_screen.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      final title = message.notification?.title ?? 'No title';
      final body = message.notification?.body ?? 'No body';
      final sendTime = DateTime.now();

      setState(() {
        _firestore.collection('notifications').add({
          'title': title,
          'body': body,
          'sendTime': sendTime,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(157, 213, 211, 1.0),
          title: const Row(
            children: [
              Icon(Icons.done_all, color: Color.fromRGBO(
                  54, 56, 84, 1.0)),
              SizedBox(width: 10,),
              Text('Bildirimler', textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(
                  54, 56, 84, 1.0)),),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500), // Geçiş süresi
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Geçiş animasyonunu özelleştirin
                    var begin = const Offset(1.0, 0.0);
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
                    return const FeedPage(); // İkinci sayfa widget'ını buraya yerleştirin
                  },
                ),
              );

            }, icon:const Icon(FontAwesomeIcons.arrowRight, size: 18,color: Color.fromRGBO(
                54, 56, 84, 1.0)))
          ]

      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(183, 220, 218, 1),
              Color.fromRGBO(187, 198, 240, 1),
              Color.fromRGBO(185, 187, 223, 1),


            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('notifications').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final sendTime = notification['sendTime'] as Timestamp;
                final formattedTime =
                    '${sendTime.toDate().day}/${sendTime.toDate().month}/${sendTime.toDate().year} ${sendTime.toDate().hour}:${sendTime.toDate().minute}:${sendTime.toDate().second}';

                return Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active, color: Color.fromRGBO(
                        137, 140, 203, 1.0) ,),
                    title: Text(notification['title'], style: const TextStyle(color: Color.fromRGBO(
                        54, 56, 84, 1.0),fontWeight: FontWeight.w600),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification['body'], style: const TextStyle(fontSize: 15),),
                        Text('Gönderilme zamanı: $formattedTime', style: const TextStyle(fontStyle: FontStyle.italic,fontSize: 11),),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}