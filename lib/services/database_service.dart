import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBase {
  final database = Supabase.instance.client;

  Future updateItem(
      {required String id,
      required String name,
      required int quantity,
      required int price,
      required String pic}) async {
    try {
      return await database.from("Items").update({
        "item": name,
        "quantity": quantity,
        "pic": pic,
        "price": price,
      }).eq("id", id);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> readItem({required int id}) async {
    try {
      final response =
          await database.from("items").select().eq("id", id).single();
      return response as Map<String, dynamic>?;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
