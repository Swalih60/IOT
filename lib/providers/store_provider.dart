import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  List<Map<String, dynamic>> get items => _items;
  bool get loading => _loading;

  void addItems({required Map<String, dynamic> item}) {
    _items.add(item);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  void setLoading() {
    _loading = false;
    notifyListeners();
  }
}
