import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  List items = [];
  bool loading = true;

  void addItems({required item}) {
    items.add(item);
    notifyListeners();
  }

  void setLoading() {
    loading = false;
    notifyListeners();
  }
}
