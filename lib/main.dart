import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_reminder/screens/feed_screen.dart';
import 'package:read_reminder/screens/login_screen.dart';
import 'package:read_reminder/screens/profile_screen.dart';
import 'package:read_reminder/screens/timer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPrintGestureArenaDiagnostics = false;
  runApp(const MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late FirebaseAuth firebaseAuth;
  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    navigateToLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToLogin() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Adjust the duration as needed

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              firebaseAuth.currentUser != null ? FeedPage() : LoginPage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/splash_img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(
                    bottom: 90,
                    right: 50,
                    child: Text(
                      'Readme!',
                      style: TextStyle(
                        color: Color(0xFF454A71),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => CoinProvider()),
        ChangeNotifierProvider(create: (context) => TimeProvider()),
    ],
      child: MaterialApp(

          theme: ThemeData(
            fontFamily: 'Lato',
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/first': (context) => TimerPage(),
            '/feed': (context) => FeedPage(),
            '/time': (context) => ProfilePage(),
//routes
          },
          debugShowCheckedModeBanner: false,


      )
    );


  }
}
