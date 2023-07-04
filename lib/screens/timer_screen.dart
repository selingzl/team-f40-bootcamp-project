import 'package:flutter/material.dart';
import 'dart:ui';


class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = _animationController.drive(
      CurveTween(curve: Curves.linear),
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
            gradient: RadialGradient(
            colors: [Color.fromRGBO(223, 244, 243, 1),
            Color.fromRGBO(218, 228, 238, 1),
            Color.fromRGBO(185, 187, 223, 1)],
            radius: 1.65,
            center: Alignment.topLeft,
    ),
    ),
                  child: Stack(
                    children :[
                      Image.asset(
                      'lib/assets/timer.png',
                      width: 200,
                      height: 200,
                    ),
                    ]
                        ),
                      ),
                    ),

                  );



  }
}



