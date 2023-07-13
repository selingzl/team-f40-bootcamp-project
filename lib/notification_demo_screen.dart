import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
   // _configureFirebaseMessaging();
  }

  /*void _configureFirebaseMessaging() {
    _firebaseMessaging.(
      onMessage: (Map<String, dynamic> message) async {
        // Bildirim alındığında yapılacak işlemler
        setState(() {
          _notifications.add(message['notification']['title']);
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        // Uygulama tamamen kapalıyken bildirime tıklandığında yapılacak işlemler
        setState(() {
          _notifications.add(message['notification']['title']);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        // Arka planda çalışırken bildirime tıklandığında yapılacak işlemler
        setState(() {
          _notifications.add(message['notification']['title']);
        });
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notifications[index]),
          );
        },
      ),
    );
  }
}
