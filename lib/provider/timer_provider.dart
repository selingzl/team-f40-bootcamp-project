import 'package:flutter/material.dart';

class TimeProvider with ChangeNotifier {
  int time = 0;

  void increaseTime(int amount) {
    time += amount;
    notifyListeners();
  }
}