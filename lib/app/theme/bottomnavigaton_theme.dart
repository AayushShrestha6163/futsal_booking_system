import 'package:flutter/material.dart';

BottomNavigationBarThemeData getBottomNavigationTheme() {
  return const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 8,
    type: BottomNavigationBarType.fixed,

   
    selectedItemColor: Color(0xFF5A9C41),
    selectedIconTheme: IconThemeData(size: 26),

   
    unselectedItemColor: Colors.grey,
    unselectedIconTheme: IconThemeData(size: 24),

   
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}
