import 'package:flutter/material.dart';
import 'package:futal_booking_system/theme/appbar_theme.dart';
import 'package:futal_booking_system/theme/bottomnavigaton_theme.dart';
import 'package:futal_booking_system/theme/elevatedbutton_theme.dart';
import 'package:futal_booking_system/theme/inputdecoration_theme.dart';
import 'package:futal_booking_system/theme/scaffold_theme.dart';


ThemeData getApplicationTheme() {
  const Color primaryColor = Color(0xFF5A9C41);

  ThemeData baseTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'OpenSans Regular',

    // COLOR SCHEME
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    // THEMES
    appBarTheme: getAppBarTheme(),
    bottomNavigationBarTheme: getBottomNavigationTheme(),
    elevatedButtonTheme: getElevatedButtonTheme(),
    inputDecorationTheme: getInputDecorationTheme(),

    // TEXT BUTTON
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    // OUTLINED BUTTON
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  // APPLY SCAFFOLD THEME
  return applyScaffoldTheme(baseTheme);
}
