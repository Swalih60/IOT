import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem({
    required String pos,
    required String item,
    required String img,
    required int quant,
    required int price,
  }) {
    _items.add({
      "item_pos": pos,
      "item_name": item,
      "item_img": img,
      "item_quant": quant,
      "item_price": price,
    });
    notifyListeners();
  }

  void removeItem({required int index}) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
