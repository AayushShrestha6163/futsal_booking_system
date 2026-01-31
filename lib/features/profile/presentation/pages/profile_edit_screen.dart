import 'package:flutter/material.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/login_screen.dart';
import 'package:futal_booking_system/features/profile/presentation/pages/edit_profile_screen.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e2c),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffea6a87),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // APP BAR
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Profile',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                // PROFILE IMAGE + NAME
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage(
                              'assets/images/profile.jpg',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aayush Shrestha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'View full profile',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // MENU ITEMS
            // const _ProfileTile(
            //   icon: Icons.person_outline,
            //   title: 'Account Information',
            // ),
            // _ProfileTile(
            //   icon: Icons.lock_outline,
            //   title: 'Password',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const PasswordScreen(),
            //       ),
            //     );
            //   },
            // ),
            _ProfileTile(
              icon: Icons.person,
              title: 'Edit Profile',
              color: const Color.fromARGB(255, 245, 228, 227),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            const _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
            ),
            const _ProfileTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
            ),

            const SizedBox(height: 40),

            // LOGOUT
            _ProfileTile(
              icon: Icons.logout,
              title: 'Log out',
              color: const Color.fromARGB(255, 228, 197, 195),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xff2a2a3c),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: color ?? Colors.white70),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(color: color ?? Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
