import 'package:flutter/material.dart';
import 'package:iot/screens/cart_screen.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({super.key});

  final List<String> urls = [
    "https://assets.ajio.com/medias/sys_master/root/20240807/8Szc/66b378076f60443f31f3a482/-473Wx593H-462760846-black-MODEL.jpg",
    "https://images.jdmagicbox.com/quickquotes/images_main/classmate-notebook-240-x-180-120-pages-unruled-back-pressed-center-stapled-164867252-lgesq.jpg",
    "https://www.bigbasket.com/media/uploads/p/l/102745_15-lays-potato-chips-american-style-cream-onion-flavour.jpg",
    "https://www.bigbasket.com/media/uploads/p/l/40094178_9-7-up-soft-drink.jpg",
    "https://www.bigbasket.com/media/uploads/p/l/102745_15-lays-potato-chips-american-style-cream-onion-flavour.jpg",
    "https://www.bigbasket.com/media/uploads/p/l/40094178_9-7-up-soft-drink.jpg",
  ];

  final List<String> names = ["PEN", "BOOK", "CHIPS", "7-UP", "CHIPS", "7-UP"];

  final List<String> quant = ["4", "7", "2", "4", "2", "0"];

  final List<String> price = ["5", "30", "10", "50", "10", "50"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SHOP"),
          centerTitle: true,
          elevation: 20,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CartScreen()));
                },
              ),
            ),
          ],
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(10),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              mainAxisExtent: 260),
          itemBuilder: (context, index) {
            bool vis = int.parse(quant[index]) > 0;
            return Offstage(
              offstage: !vis,
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(
                        urls[index],
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Text(names[index]),
                    Text("Quantity : ${quant[index]}"),
                    Text("Price : ${price[index]}"),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: const Icon(Icons.shopping_cart))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
