import 'package:flutter/material.dart';
import 'package:futal_booking_system/features/profile/presentation/pages/profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Center(child: ProfileEditScreen()));
  }
}
