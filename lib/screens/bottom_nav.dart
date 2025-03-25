// import 'package:flutter/material.dart';
// import 'package:iot/providers/bottom_nav_provider.dart';
// import 'package:iot/screens/profile_screen.dart';
// import 'package:iot/screens/store_screen.dart';
// import 'package:provider/provider.dart';

// class NavScreen extends StatelessWidget {
//   NavScreen({super.key});

//   final list = [const StoreScreen(), const ProfileScreen()];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: list[context.watch<BottomProvider>().currentIndex],
//       bottomNavigationBar: Container(
//         height: 80,
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () => context.read<BottomProvider>().changeIndex(index: 0),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width:
//                     context.watch<BottomProvider>().currentIndex == 0 ? 70 : 60,
//                 height:
//                     context.watch<BottomProvider>().currentIndex == 0 ? 50 : 40,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 232, 226, 226),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Icon(
//                   Icons.store,
//                   color: Colors.black,
//                   size: context.watch<BottomProvider>().currentIndex == 0
//                       ? 35
//                       : 30,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () => context.read<BottomProvider>().changeIndex(index: 1),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width:
//                     context.watch<BottomProvider>().currentIndex == 1 ? 70 : 60,
//                 height:
//                     context.watch<BottomProvider>().currentIndex == 1 ? 50 : 40,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 232, 226, 226),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Icon(
//                   Icons.person,
//                   color: Colors.black,
//                   size: context.watch<BottomProvider>().currentIndex == 1
//                       ? 35
//                       : 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
