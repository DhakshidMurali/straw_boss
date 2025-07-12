// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:sp_app/Modules/Shared/Screens/SHHomeScreen.dart';
// import 'package:sp_app/Modules/Shared/Screens/SubjectListScreen.dart';
//
// class BottomNavBar extends StatelessWidget {
//   var icons = [
//     Icons.home,
//     Icons.label,
//     Icons.my_library_books,
//     Icons.settings,
//   ];
//   int currentIndex = 0;
//   BottomNavBar(this.currentIndex);
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBottomNavigationBar(
//       elevation: 20,
//       onTap: (index) {
//         if (index == currentIndex) return;
//         if (index == 0) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => SHHomeScreen()),
//           );
//         }
//         if (index == 1) {}
//         if (index == 2) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => SubjectListScreen()),
//           );
//         }
//         if (index == 3) {}
//       },
//       activeIndex: currentIndex,
//       icons: icons,
//       backgroundColor: Colors.white,
//       inactiveColor: Colors.indigo,
//       activeColor: Colors.lightBlue,
//       height: 60,
//       gapLocation: GapLocation.center,
//       notchSmoothness: NotchSmoothness.verySmoothEdge,
//     );
//   }
// }
