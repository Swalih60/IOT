import 'package:supabase_flutter/supabase_flutter.dart';

class Storage {
  final storage = Supabase.instance.client.storage;

  Future<void> uploadPic(
      {required img, required String uid, required String filename}) async {
    await storage.from("item_bucket").upload('$uid/$filename/', img);
  }
}
