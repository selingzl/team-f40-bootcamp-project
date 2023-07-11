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
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userEmail = currentUser.email ?? 'Email alınamadı!';
      });
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
              Text(
                userEmail,
                style: TextStyle(
                  color: Color.fromRGBO(54, 56, 84, 1.0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                        Consumer<TimeProvider>(
                          builder: (context, timeProvider, _) {
                            int time = timeProvider.time;
                            return Text(
                              '$time saat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(69, 74, 113, 1.0),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
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
                    height: 70,
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
              const SizedBox(height: 30,),
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
