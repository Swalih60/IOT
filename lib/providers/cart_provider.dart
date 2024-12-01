import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List item_name = [];
  List item_img = [];

  void addItem({required String item, required String img}) {
    item_name.add(item);
    item_img.add(img);
  }

  void removeItem({required int index}) {
    item_name.removeAt(index);
    item_img.removeAt(index);
  }
}
