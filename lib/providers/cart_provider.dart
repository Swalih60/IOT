import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // List item_name = [];
  // List item_img = [];
  // List item_quant = [];

  List<Map<String, dynamic>> items = [];

  void addItem(
      {required String item, required String img, required int quant}) {
    // item_name.add(item);
    // item_img.add(img);
    // item_quant.add(quant);
    items.add({
      "item_name": item,
      "item_img": img,
      "item_quant": quant,
    });
  }

  void removeItem({required int index}) {
    // item_name.removeAt(index);
    // item_img.removeAt(index);
    // item_quant.removeAt(index);
    items.removeAt(index);
  }
}
