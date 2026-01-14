import 'package:flutter/material.dart';

ThemeData applyScaffoldTheme(ThemeData theme) {
  return theme.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
