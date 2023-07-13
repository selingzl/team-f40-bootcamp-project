import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:read_reminder/screens/donateList_screen.dart';
import 'login_screen.dart';
import 'timer_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName= '';
  String id= '';


  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        id = currentUser.uid ?? 'id alınamadı!';
      });
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('8OIavQTKxT9bv6wa6qlR')
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['username'];
        });
        print('ad yok');
      } else {
        setState(() {
          userName = '';
          print('problem');
        });
      }
    } catch (e) {
      print('Hata: $e');
    }
  }


  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _goToDonate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => donateListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    id = FirebaseAuth.instance.currentUser!.uid;

    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 159,
                height: 159,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'lib/assets/background/bg_profile.png',
                  ), // Kullanıcı resminin yolunu güncelleyin
                ),
              ),
              SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('8OIavQTKxT9bv6wa6qlR') // Belge ID'sini buraya girin
                    .snapshots(),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                var data = snapshot.data!.data();
                  if (data != null && data.containsKey('username')) {
                    String userName = data['username'];
                return Center(
                  child: Text(
                    userName,
                    style: TextStyle(
                      color: Color.fromRGBO(54, 56, 84, 1.0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )));
                    }
                    }
                    return Center(
                        child: Text('Kullanıcı Bulunamadı'),
    );
    },
    ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Odaklanılan Süre',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(69, 74, 113, 1.0),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              FontAwesomeIcons.clock,
                              size: 14,
                              color: Color.fromRGBO(54, 56, 84, 1.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),




                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yapılan Bağışlar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(69, 74, 113, 1.0),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              FontAwesomeIcons.book,
                              size: 14,
                              color: Color.fromRGBO(69, 74, 113, 1.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '16',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(69, 74, 113, 1.0),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.50,
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Liste Sıralaması',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(69, 74, 113, 1.0),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '38.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(69, 74, 113, 1.0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: _goToDonate,
                                icon: const Icon(
                                  FontAwesomeIcons.caretRight,
                                  size: 24,
                                  color: Color.fromRGBO(117, 125, 185, 1),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(135, 142, 205, 1)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 13.0, horizontal: 35.0),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(51.16),
                    ),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Bağış yapıldı',
                              style: TextStyle(
                                color: Color.fromRGBO(69, 74, 113, 1.0),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'BAĞIŞ YAP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(69, 74, 113, 1.0),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              TextButton(
                onPressed: () {
                  _signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Icon(
                  Icons.exit_to_app,
                  color: Color.fromRGBO(135, 142, 205, 1),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
