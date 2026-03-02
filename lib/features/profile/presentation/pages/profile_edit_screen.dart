import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/login_screen.dart';
import 'package:futal_booking_system/features/profile/presentation/pages/edit_profile_screen.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  String? username; // we saved "First Last" here
  String? profilePath; // "/uploads/xyz.jpg"

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = ref.read(userSessionServiceProvider);

    // ✅ Use your existing methods
    final name = session.getCurrentUserUsername();
    final pp = session.getCurrentUserProfilePicture();

    if (!mounted) return;
    setState(() {
      username = name;
      profilePath = pp;
    });
  }

  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    // ✅ Refresh after returning
    await _loadSession();
  }

  String get displayName {
    final name = (username ?? '').trim();
    return name.isEmpty ? 'User' : name;
  }

  ImageProvider? get profileImage {
    if (profilePath == null || profilePath!.trim().isEmpty) return null;
    final url = "${ApiEndpoints.baseUrl}${profilePath!}";
    return NetworkImage(url);
  }

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
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: profileImage,
                            backgroundColor: Colors.white,
                            child: profileImage == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                          InkWell(
                            onTap: _goToEditProfile,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        displayName,
                        style: const TextStyle(
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

            _ProfileTile(
              icon: Icons.person,
              title: 'Edit Profile',
              color: const Color.fromARGB(255, 245, 228, 227),
              onTap: _goToEditProfile,
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

            _ProfileTile(
              icon: Icons.logout,
              title: 'Log out',
              color: const Color.fromARGB(255, 228, 197, 195),
              onTap: () async {
                // ✅ Use your real method name
                final session = ref.read(userSessionServiceProvider);
                await session.clearSession();

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