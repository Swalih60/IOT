import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PROFILE"),
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
              SizedBox(
                height: 10,
              ),
              Text(
                "SWALIH ZAMNOON PM",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "CSE",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "S8",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ));
  }
}
