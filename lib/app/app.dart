import 'package:flutter/material.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/splash_screen.dart';
import 'package:futal_booking_system/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(), 
      home: const SplashScreen(),
    );
  }
}
