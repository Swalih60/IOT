import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/auth/login_screen.dart';
import 'package:iot/providers/store_provider.dart';
import 'package:iot/services/database_service.dart';
import 'package:iot/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  SupaBase db = SupaBase();
  Storage st = Storage();

  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      for (int i = 1; i <= 6; i++) {
        final item = await db.readItem(id: i);
        if (item != null) {
          // ignore: use_build_context_synchronously
          context.read<StoreProvider>().addItems(item: item);
        }
      }
      // ignore: use_build_context_synchronously
      context.read<StoreProvider>().setLoading();
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ADMIN"),
          centerTitle: true,
          elevation: 20,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                child: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut().then((value) =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const GlassLoginScreen(),
                      )));
                },
              ),
            ),
          ],
        ),
        body: context.watch<StoreProvider>().loading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 350),
                itemBuilder: (context, index) {
                  final item = context.watch<StoreProvider>().items[index];
                  final String name = item["item"] ?? "unknown";
                  final int quant = item["quantity"] ?? 0;
                  final String pic = item["pic"] ?? "unknown";
                  final int price = item["price"] ?? 0;
                  bool vis = quant > 0;

                  TextEditingController t1 = TextEditingController(text: name);

                  TextEditingController t2 =
                      TextEditingController(text: "count: $quant");
                  TextEditingController t3 =
                      TextEditingController(text: "\$ : $price");

                  return Offstage(
                    offstage: !vis,
                    child: Card(
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: Image.network(
                                pic,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: t1,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: TextField(
                              controller: t2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: t3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                String publicUrl;

                                if (_image == null) {
                                  publicUrl = pic;
                                } else {
                                  publicUrl = await st.uploadPic(
                                    img: _image,
                                    filename: index.toString(),
                                  );
                                }

                                await db.updateItem(
                                  id: (index + 1).toString(),
                                  name: t1.text,
                                  quantity:
                                      int.parse(t2.text.split(':').last.trim()),
                                  price:
                                      int.parse(t3.text.split(':').last.trim()),
                                  pic: publicUrl,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item updated successfully."),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                print("Error updating item: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text("Update"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
