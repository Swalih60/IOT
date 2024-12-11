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
      body: list[context.watch<BottomProvider>().currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purple,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(size: 50),
        unselectedIconTheme: const IconThemeData(size: 30),
        elevation: 0,
        currentIndex: context.watch<BottomProvider>().currentIndex,
        onTap: (value) {
          context.read<BottomProvider>().changeIndex(index: value);
        },
      ),
    );
  }
}
