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
      return await database.from("items").update({
        "item": name,
        "quantity": quantity,
        "pic": pic,
        "price": price,
      }).eq("id", id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> decrementQuant({
    required String name,
    required int decrementValue,
  }) async {
    try {
      // Fetch the current quantity
      final response = await database
          .from('items')
          .select('quantity')
          .eq('item', name)
          .maybeSingle(); // Fetch a single row

      // Check if the response has data
      if (response != null && response['quantity'] != null) {
        int currentQuantity = response['quantity'];

        // Ensure we don't decrement below 0
        if (currentQuantity >= decrementValue) {
          int newQuantity = currentQuantity - decrementValue;

          // Update the row with the new quantity
          final updateResponse = await Supabase.instance.client
              .from('items')
              .update({'quantity': newQuantity}).eq('item', name);

          if (updateResponse.error == null) {
            print("Quantity updated successfully");
          } else {
            print("Error updating quantity: ${updateResponse.error!.message}");
          }
        } else {
          print(
              "Error: Insufficient stock for item $name. Current quantity: $currentQuantity.");
        }
      } else {
        print("Error: No item found with name $name.");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future readItem({required int id}) async {
    try {
      final response =
          await database.from("items").select().eq("id", id).single();
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
