import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PROFILE"),
          elevation: 5,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.purple),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "SWALIH ZAMNOON PM",
                style: TextStyle(fontSize: 30),
              ),
              const Text(
                "CSE",
                style: TextStyle(fontSize: 30),
              ),
              const Text(
                "S8",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ));
  }
}
