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
  String? username;
  String? profilePath;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = ref.read(userSessionServiceProvider);
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
    await _loadSession();
  }

  String get displayName {
    final name = (username ?? '').trim();
    return name.isEmpty ? 'User' : name;
  }

  ImageProvider? get profileImage {
    if (profilePath == null || profilePath!.trim().isEmpty) return null;

    if (profilePath!.startsWith('/uploads')) {
      return NetworkImage("${ApiEndpoints.baseUrl}${profilePath!}");
    }

    if (profilePath!.startsWith('http://') ||
        profilePath!.startsWith('https://')) {
      return NetworkImage(profilePath!);
    }

    return NetworkImage("${ApiEndpoints.baseUrl}${profilePath!}");
  }

  Future<void> _logout() async {
    final session = ref.read(userSessionServiceProvider);

    // Clear only active login session
    // Keep biometric data so fingerprint login can still work
    await session.clearLoginSession();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B1220);
    const card = Color(0xFF121B2E);
    const border = Color(0x1AFFFFFF);
    const primary = Color(0xFF16A34A);
    const secondary = Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: bg,
            elevation: 0,
            pinned: true,
            expandedHeight: 240,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF16A34A),
                      Color(0xFF0EA5E9),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white,
                                backgroundImage: profileImage,
                                child: profileImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 42,
                                        color: Colors.black54,
                                      )
                                    : null,
                              ),
                            ),
                            InkWell(
                              onTap: _goToEditProfile,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Manage your account & profile details",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: "Edit Profile",
                          subtitle: "Name, photo",
                          icon: Icons.person_outline,
                          bg: card,
                          border: border,
                          onTap: _goToEditProfile,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          primary.withOpacity(0.15),
                          secondary.withOpacity(0.12),
                        ],
                      ),
                      border: Border.all(color: border),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        "Sign out from this device",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white70,
                      ),
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color border;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
    required this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x12000000),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}