import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/dashboard/presentation/pages/bottomScreen/booking_screen.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/booking_stats_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionServiceProvider);

    final fullName = session.getCurrentUserUsername() ?? "User";
    final profilePic = session.getCurrentUserProfilePicture();

    
    final totalBookings = ref.watch(totalBookingsProvider);
    final hoursPlayed = ref.watch(hoursPlayedProvider);

    return Scaffold(
      backgroundColor: const Color(0xffe9f0ef),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: _getProfileImage(profilePic),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hey, $fullName 👋',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ===== Location =====
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Nepal, Kathmandu',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

             
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Total Bookings",
                      value: totalBookings.toString(),
                      icon: Icons.calendar_month,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Hours Played",
                      value: hoursPlayed,
                      icon: Icons.access_time,
                      iconColor: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xff2ecc71), Color(0xff27ae60)],
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.sports_soccer,
                        size: 80, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Book Venues With The Best Offers!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingScreen(),
                          ),
                        );
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  ImageProvider _getProfileImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/images/profile.jpg');
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    return FileImage(File(path));
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Icon(icon, size: 22, color: iconColor),
        ],
      ),
    );
  }
}