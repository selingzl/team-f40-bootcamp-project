import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'feed_screen.dart';



class SendMessagePage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String recipientName;

  SendMessagePage({
    required this.senderId,
    required this.receiverId,
    required this.recipientName,
  });

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String messageContent) {
    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': messageContent,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final conversationId = getConversationId(senderId, receiverId);

    FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(messageData);

    _messageController.clear();
  }

  String getConversationId(String senderId, String receiverId) {
    if (senderId.hashCode <= receiverId.hashCode) {
      return '$senderId-$receiverId';
    } else {
      return '$receiverId-$senderId';
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationId = getConversationId(senderId, receiverId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(187, 198, 240, 1),
        title: Text(
          recipientName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(82, 87, 124, 1.0),
            fontSize: 24,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(223, 229, 243, 1.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('conversations')
                    .doc(conversationId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Mesajlar Yükleniyor'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final messageData =
                          messages[index].data() as Map<String, dynamic>;
                      final content = messageData['content'];
                      final isCurrentUser = (messageData['senderId'] == senderId);

                      return Align(
                        alignment: (isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: (isCurrentUser
                                ? Color.fromRGBO(151, 159, 225, 1.0)
                                : Color.fromRGBO(225, 243, 238, 1.0)),
                            borderRadius: isCurrentUser
                                ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )
                                : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              color: (isCurrentUser
                                  ? Color.fromRGBO(214, 245, 241, 1.0)
                                  : Color.fromRGBO(82, 87, 124, 1.0))),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20,left: 20,bottom: 40,top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: const EdgeInsets.only(
                          right: 5, left: 15, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                        color: Color.fromRGBO(179, 187, 234, 1.0),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: TextField(
                        controller: _messageController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintText: 'Mesajınızı yazın...',
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromRGBO(99, 104, 145, 1.0)))
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Color.fromRGBO(99, 104, 145, 1.0),
                      size: 27,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    onPressed: () {
                      final messageContent = _messageController.text.trim();
                      if (messageContent.isNotEmpty) {
                        _sendMessage(messageContent);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
