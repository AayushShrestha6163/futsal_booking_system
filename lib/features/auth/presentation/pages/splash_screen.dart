import 'package:flutter/material.dart';
import 'onbording_screen.dart'; // this must contain Onboarding1

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // ✅ important

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Onboarding1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}