import 'package:flutter/foundation.dart';

class ValueProvider extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }

  void reset() {
    value = 0;
    notifyListeners();
  }
}
