import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'conversation_screen.dart';
import 'feed_screen.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Center(
        child: Scrollbar(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(207, 236, 234, 1.0),
                  Color.fromRGBO(185, 187, 223, 1),
                ],
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FeedPage()),
                          );
                        },
                        icon: const Icon(
                          FontAwesomeIcons.caretLeft,
                          size: 28,
                          color: Color.fromRGBO(117, 125, 185, 1),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Kullanıcılar',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 1),
                            blurRadius: 5,
                          ),
                        ],
                        fontSize: 26,
                        color: Color.fromRGBO(117, 125, 185, 1),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        final users = snapshot.data!.docs;

                        final filteredUsers = users
                            .where((user) => user.id != currentUserUid)
                            .toList();

                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final userData = filteredUsers[index].data()
                                as Map<String, dynamic>;
                            final userName = userData['username'] ??
                                'İsim Bilgisi Alınamadı!!!';
                            final userId = userData['userId'];
                            final pp = userData['profileImage'];
                            String imageUrl;
                            if(pp == null || pp == ''){
                              imageUrl = 'https://firebasestorage.googleapis.com/v0/b/f40-bootcamp-project.appspot.com/o/profile_images%2F1689352459687817.jpg?alt=media&token=5adc797a-d57a-4c20-ac54-23edc0c2121d';

                            }else{
                            imageUrl = pp;
                            }

                            final lastRead =
                                userData['lastReadDate'] ?? 'okuma yok';
                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(lastRead.toDate());
                            return Container(
                              child: ListTile(
                                title: Container(
                                    margin: EdgeInsets.only(
                                        right: 20, bottom: 5, top: 10),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(207, 236, 234, 1.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            bottomLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(5),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50), // İstediğiniz yuvarlaklık derecesini belirleyebilirsiniz
                                              child: Image.network(
                                                imageUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userName,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      97, 104, 154, 1.0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                                'son kitap okuma: $formattedDateTime',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        67, 72, 108, 1.0),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400))
                                          ],
                                        ),
                                      ],
                                    )),
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

