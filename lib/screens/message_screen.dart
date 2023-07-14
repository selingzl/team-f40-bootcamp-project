import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;
              final userName = userData['username'] ?? 'İsim Bilgisi Alınamadı!!';

              return ListTile(
                title: Text(userName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendMessagePage(
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        receiverId: userId,
                        recipientName: userName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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

    FirebaseFirestore.instance.collection('messages').add(messageData);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('senderId', isEqualTo: senderId)
                  .where('receiverId', isEqualTo: receiverId)
                  //.orderBy('timestamp', descending: true)
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
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final content = messageData['content'];
                    final isCurrentUser = (messageData['senderId'] == senderId);

                    return Align(
                      alignment: (isCurrentUser ? Alignment.centerRight : Alignment.centerLeft),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isCurrentUser ? Colors.blue : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          content,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
    );
  }
}
