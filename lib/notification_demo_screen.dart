import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text('Bildirimler'),
        actions: [Icon(Icons.done_all),
        SizedBox(width: 10,)
        ]

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final sendTime = notification['sendTime'] as Timestamp;

              final formattedTime =
                  '${sendTime.toDate().day}/${sendTime.toDate().month}/${sendTime.toDate().year} ${sendTime.toDate().hour}:${sendTime.toDate().minute}:${sendTime.toDate().second}';

              return ListTile(

                leading: Icon(Icons.notifications_active),
                title: Text(notification['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification['body']),
                    Text('Gönderilme zamanı: $formattedTime'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
