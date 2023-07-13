import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'feed_screen.dart';


class Message {
  final String sender;
  final String recipient;
  final String content;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.recipient,
    required this.content,
    required this.timestamp,
  });

  // Firestore'a döküman olarak kaydetmek için bir dönüştürücü metot
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'content': content,
      'timestamp': '${timestamp.year}-${timestamp.month}-${timestamp.day} ${timestamp.hour}:${timestamp.minute}',
    };
  }
}

String formatTimestamp(DateTime timestamp) {
  final day = timestamp.day.toString().padLeft(2, '0');
  final month = timestamp.month.toString().padLeft(2, '0');
  final year = timestamp.year.toString();
  final hour = timestamp.hour.toString().padLeft(2, '0');
  final minute = timestamp.minute.toString().padLeft(2, '0');

  return '$day/$month/$year $hour:$minute';
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;


  const MessageBubble({required this.message, required this.isMe});
  // Firestore dökümanı olarak kaydetmek için bir dönüştürücü metot
  Map<String, dynamic> toMap() {
    return message.toMap();
  }



  @override
  Widget build(BuildContext context) {
    final timestamp = formatTimestamp(message.timestamp);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.sender,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: isMe ?  Color.fromRGBO(143, 146, 203, 1.0) : Color.fromRGBO(
                205, 245, 240, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Color.fromRGBO(225, 241, 240, 1.0) : Color.fromRGBO(
                      70, 73, 108, 1.0),
                ),
              ),
            ),
          ),
          Text(
            timestamp.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [];

  CollectionReference messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  final TextEditingController _messageController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool isMe = true; // Başlangıçta mesajları kendiniz gönderdiğinizi varsayalım
  List<String> _searchResult = [];
  //Örnek
  final List<String> _dataList = [
    'Apple',
    'Banana',
    'Orange',
    'Grapes',
    'Watermelon',
    'Mango',
  ];

  void sendMessage(String messageContent) {
    // Simülasyon amaçlı olarak mesajı ekleyelim
    Message newMessage = Message(
      sender: isMe ? 'Me' : 'John',
      content: messageContent,
      timestamp: DateTime.now(), recipient: '',
    );


    setState(() {
      messages.add(newMessage);
      isMe = !isMe;
    });
    messagesCollection.add(newMessage.toMap());
  }

  void _performSearch(String searchTerm) {
    setState(() {
      _searchResult = _dataList
          .where((item) => item.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromRGBO(223, 244, 243, 1),
                Color.fromRGBO(218, 228, 238, 1),
                Color.fromRGBO(185, 187, 223, 1),
              ],
              radius: 1.65,
              center: Alignment.topLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Row(
                  children: [
                    IconButton( onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedPage()),
                      );
                    }, icon: Icon(FontAwesomeIcons.backward,color: Color.fromRGBO(185, 187, 223, 1), )),
                    SizedBox(width: 20,),
                    Container(
                      width: 300,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _performSearch,
                              decoration: InputDecoration(
                                hintText: 'Kullanıcı...',
                              ),),
                          ),
                          Flexible(
                            child: ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: TextButton(onPressed: () {  }, //kullanıcıyı seçecek ve mesajlar ona göre düzenlenecek
                                    child: Text(_searchResult[index], style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(
                                        84, 62, 143, 1.0), fontSize: 16),),),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = messages[index];
                        bool isMessageFromMe = message.sender == 'Me'; // Mesaj benim tarafımdan mı gönderildi?
                        return MessageBubble(message: message, isMe: isMessageFromMe);}
                  ),),
                Padding(
                  padding: EdgeInsets.all(10.0),
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
                        icon: Icon(Icons.send, color:Color.fromRGBO(
                            84, 62, 143, 1.0)),
                        onPressed: () {
                          String messageContent = _messageController.text.trim();
                          if (messageContent.isNotEmpty) {
                            sendMessage(messageContent);
                            _messageController.clear();
                          }
                        },
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),

        ),
      ),
    );
  }
}







