import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'conversation_screen.dart';
import 'feed_screen.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    //=>To check whether the conversation info is taken before or not in order to prevent copy of data;
    String getConversationId(String senderId, String receiverId) {
      if (senderId.hashCode <= receiverId.hashCode) {
        return '$senderId-$receiverId';
      } else {
        return '$receiverId-$senderId';
      }
    }

    return Scaffold(
        body: Center(
      child: Scrollbar(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(207, 236, 234, 1.0),
                Color.fromRGBO(185, 187, 223, 1),
              ],
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        // Geçiş süresi
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
                  },
                  icon: const Icon(
                    FontAwesomeIcons.caretRight,
                    size: 28,
                    color: Color.fromRGBO(117, 125, 185, 1),
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            Text(
              'Konuşma Geçmişi',
              style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ],
                  fontSize: 26,
                  color: const Color.fromRGBO(117, 125, 185, 1),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('conversations2')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final conversationDocs = snapshot.data!.docs;
                  //=>'conversationMap' is used to prevent copy of data if more than one data is returned for the current user;
                  final conversationMap = <String, dynamic>{};

                  for (final conversationDoc in conversationDocs) {
                    final senderId = conversationDoc['senderId'];
                    final receiverId = conversationDoc['receiverId'];

                    if (senderId == currentUserUid ||
                        receiverId == currentUserUid) {
                      final conversationId =
                          getConversationId(senderId, receiverId);
                      if (!conversationMap.containsKey(conversationId)) {
                        conversationMap[conversationId] =
                            conversationDoc.data();
                      }
                    }
                  }
                  final filteredDocs = conversationMap.values.toList();

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final conversationDoc = filteredDocs[index];

                      final lastMessageDate = conversationDoc['timestamp'];
                      final localDateTime = lastMessageDate
                          .toDate()
                          .toUtc()
                          .add(const Duration(hours: 3)); // Convert to UTC+3
                      String formattedDateTime =
                          DateFormat('dd-MM-yyyy - HH:mm:ss')
                              .format(localDateTime);

                      final senderId = conversationDoc['senderId'];
                      final receiverId = conversationDoc['receiverId'];

                      // Determine the other user's ID
                      final otherUserId =
                          senderId == currentUserUid ? receiverId : senderId;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('userId', isEqualTo: otherUserId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final userDoc = snapshot.data!.docs.first;
                          final userData =
                              userDoc.data() as Map<String, dynamic>;
                          final userName = userData['username'] ??
                              'İsim Bilgisi Alınamadı!!!';
                          final userId = userData['userId'];
                          final pp = userData['profileImage'];
                          String imageUrl;
                          if (pp == null || pp == '') {
                            imageUrl =
                                'https://firebasestorage.googleapis.com/v0/b/f40-bootcamp-project.appspot.com/o/profile_images%2F1689352459687817.jpg?alt=media&token=5adc797a-d57a-4c20-ac54-23edc0c2121d';
                          } else {
                            imageUrl = pp;
                          }

                          /*final lastRead =
                                    userData['lastReadDate'] ?? 'okuma yok';
                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(lastRead.toDate());*/

                          return ListTile(
                            title: Container(
                              margin: const EdgeInsets.only(
                                  right: 20, bottom: 5, top: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(207, 236, 234, 1.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(
                                              97, 104, 154, 1.0),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        'son mesaj: $formattedDateTime',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(
                                              67, 72, 108, 1.0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendMessagePage(
                                    senderId: currentUserUid,
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
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}