import 'package:flutter/material.dart';

AppBarTheme getAppBarTheme() {
  return const AppBarTheme(
    centerTitle: true,
    elevation: 0,

    // BACKGROUND & FOREGROUND
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,

    // TITLE STYLE
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),

    // ICON THEME
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 24,
    ),
  );
}
