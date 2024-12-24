import 'package:flutter/material.dart';
import 'package:iot/providers/bottom_nav_provider.dart';
import 'package:iot/screens/profile_screen.dart';
import 'package:iot/screens/store_screen.dart';
import 'package:provider/provider.dart';

class NavScreen extends StatelessWidget {
  NavScreen({super.key});

  final list = [const StoreScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: list[context.watch<BottomProvider>().currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: 60,
              height: 40,
              child: Icon(
                Icons.store,
                color: Colors.black,
                size: 30,
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 226, 226),
                  borderRadius: BorderRadius.circular(100)),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 60,
              height: 40,
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 30,
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 226, 226),
                  borderRadius: BorderRadius.circular(100)),
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(
          size: 50,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 30,
        ),
        elevation: 0,
        currentIndex: context.watch<BottomProvider>().currentIndex,
        onTap: (value) {
          context.read<BottomProvider>().changeIndex(index: value);
        },
      ),
    );
  }
}
