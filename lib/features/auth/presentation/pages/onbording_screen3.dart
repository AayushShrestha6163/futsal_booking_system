import 'package:flutter/material.dart';
import 'package:futal_booking_system/widget/my_button.dart';

import 'login_screen.dart';
// import 'package:futal_booking_system/screen/onbording_screen2.dart';


class OnbordingScreen3 extends StatelessWidget {
  const OnbordingScreen3({super.key});

  void _goToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _skipToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              Expanded(
                flex: 3,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.asset(
                        'assets/images/profile.jpg',
                        width: constraints.maxWidth * 0.8,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),

              const Spacer(flex: 1),

              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Manage your bookings and personal information easily',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Spacer(flex: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextButton(
                      onPressed: () => _skipToLogin(context),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF2D6AF0),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    child: MyButton(
                      onPressed: () => _goToNext(context),
                      text: 'Next',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
