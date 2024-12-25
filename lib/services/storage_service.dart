import 'package:supabase_flutter/supabase_flutter.dart';

class Storage {
  final storage = Supabase.instance.client.storage;

  Future<String> uploadPic({required img, required String filename}) async {
    await storage.from("item_bucket").upload('ADMIN/$filename', img);

    final publicUrl =
        storage.from("item_bucket").getPublicUrl('ADMIN/$filename');
    return publicUrl;
  }
}
