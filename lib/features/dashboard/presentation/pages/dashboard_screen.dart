import 'package:flutter/material.dart';
import 'package:futal_booking_system/features/dashboard/presentation/pages/bottomScreen/gyroscope_screen.dart';
import 'bottomScreen/booking_screen.dart';

import 'bottomScreen/home_screen.dart';
import 'bottomScreen/profile_screen.dart';
import 'bottomScreen/mybookings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookScreen(),
    const ProfileScreen(),
    const MyBookingsScreen(),
    const GyroscopeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "mybookings"),
          BottomNavigationBarItem(icon: Icon(Icons.screen_rotation), label: "Gyro"), 
        ],
        backgroundColor: Color.fromARGB(255, 46, 226, 61),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
