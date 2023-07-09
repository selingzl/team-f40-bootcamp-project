import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TimerPage extends StatefulWidget {
  final String bookName;

  const TimerPage({super.key, String? bookName}) : bookName = bookName ?? '';

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    {

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userId;
    if (user != null) {
      userId = user!.uid;
    }

    CollectionReference userBooksCollection =
    FirebaseFirestore.instance.collection('userBooks');
      Future<void> addUser() {
        return userBooksCollection
            .add({
          'bookName': widget.bookName,
          'comment': '',
          'spentTime': 2, //2 yerine timer durduruldugunda alinan sure gelecek
          'userId': userId
        })
            .then((value) => print('User added successfully'))
            .catchError((error) => print('Failed to add user: $error'));
      }

      Future<void> updateUser(DocumentSnapshot bookDoc) {
        Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
        int oldSpentTimeVal = bookData['spentTime'];
        int updatedSpentTime = oldSpentTimeVal +
            2;

        DocumentReference userBookDocRef = bookDoc.reference;
        return userBookDocRef
            .update({'spentTime': updatedSpentTime})
            .then((value) => print('userBook data is updated successfully'))
            .catchError(
                (error) => print('Failed to update userBook data: $error'));
      }

      //Bu metodu timer durduruldugunda cagirman gerekiyor. Boylece login olan kullanici icin mevcut olarak okunan kitapla ilgili
      //Firestore'da kayit varsa, bu kayittaki kitap icin okunan sure guncellenir veya bununla ilgili yeni kayit eklenir.

    Future<void> addOrUpdateUserBook() async {
        QuerySnapshot querySnapshot = await userBooksCollection
            .where('userId', isEqualTo: userId)
            .where('bookName', isEqualTo: 'your_book_name')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot bookDocument = querySnapshot.docs.first;
          await updateUser(bookDocument);
        } else {
          // User record doesn't exist, add a new record
          await addUser();
        }
      }
        return const Scaffold(
            body: Center(
              child: RotatingImages(),
            )

        );
      }
    }


class RotatingImages extends StatefulWidget {
  const RotatingImages({super.key});


  @override
  _RotatingImagesState createState() => _RotatingImagesState();
}

class _RotatingImagesState extends State<RotatingImages>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isRotating = false;
  final Stopwatch _stopwatch = Stopwatch();
  bool _isRunning = false;
  int hours1 = 0;
  int minutes1 = 0;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _toggleRotation() {
    setState(() {
      if (_isRotating) {
        _animationController.stop();
      } else {
        _animationController.repeat();
      }
      _isRotating = !_isRotating;
    });
  }
  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
      _elapsedTime++;
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
      _elapsedTime = 0;
    });
  }

  void increaseHTime(int amount){
    hours1 += amount;
  }
  void increaseMTime(int amount){
    minutes1 += amount;
  }


  @override
  Widget build(BuildContext context) {
    String getTimerText() {
      int milliseconds = _stopwatch.elapsedMilliseconds;
      int seconds = (milliseconds / 1000).floor() % 60;
      int minutes = (milliseconds / (1000 * 60)).floor() % 60;
      int hours = (milliseconds / (1000 * 60 * 60)).floor();

      String hoursStr = (hours < 10) ? '0$hours' : hours.toString();
      String minutesStr = (minutes < 10) ? '0$minutes' : minutes.toString();
      String secondsStr = (seconds < 10) ? '0$seconds' : seconds.toString();

      return '$hoursStr:$minutesStr:$secondsStr';
    }
    Duration duration = _stopwatch.elapsed;
    int second = duration.inSeconds;
    int minutes = duration.inMinutes;
    int hours = duration.inHours;

    return Container(
      padding: const EdgeInsets.all(10),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            Text(
              getTimerText(),
              style: const TextStyle(fontSize: 36, color: Color.fromRGBO(
                  82, 87, 124, 1.0),),
            ),
            GestureDetector(
              onTap: (){
                if (_isRunning & !_isRotating) {
                  _stopStopwatch();
                  _resetStopwatch();
                  _isRotating = false ;
                  CoinProvider coinProvider = Provider.of<CoinProvider>(context, listen: false);
                  TimeProvider timeProvider = Provider.of<TimeProvider>(context, listen: false);

                  if(hours < 1){
                    coinProvider.increaseCoin(0);
                    timeProvider.increaseTime(0);
                  }
                  else {
                    coinProvider.increaseCoin(hours*100);
                    timeProvider.increaseTime(hours);
                  }
                  increaseHTime(hours);
                  increaseMTime(minutes);
                } else {
                  _toggleRotation();
                  _startStopwatch();
                }
              },
              child: SizedBox(
                width: 400,
                height: 400,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: _animation,
                          child: Image.asset(
                            'lib/assets/halka2.png',
                            width:285,
                            height: 280,
                          ),
                        ),
                      ),),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: _animation,
                          child: Image.asset(
                            'lib/assets/halka1.png',
                            width:330,
                            height: 330,
                          ),
                        ),
                      ),),
                    Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'lib/assets/timer.png',
                          width: 230,
                          height: 230,
                        ),
                      ),),
                  ],
                ),
              ),
            ),
            Text('En son geçen süre: $hours1 s $minutes1 dk ',
              style: const TextStyle(fontSize:16, fontStyle: FontStyle.italic,
                  color: Color.fromRGBO(84, 90, 128, 1.0)),),
          ],

        ),
      ),

    );
  }
}
class CoinProvider with ChangeNotifier {
  int coin = 0;

  void increaseCoin(int amount) {
    coin += amount;
    notifyListeners();
  }
}
class TimeProvider with ChangeNotifier{
  int time = 0;

  void increaseTime(int amount){
    time += amount;
    notifyListeners();
  }
}