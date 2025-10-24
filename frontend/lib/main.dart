import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import the screens
import 'notifications_screen.dart';
import 'popular_courses_screen.dart';
import 'top_mentors_screen.dart';

// --- Color Helpers & Global Colors ---
Color hexToColor(String hexCode) {
  String colorString = 'FF${hexCode.substring(1)}';
  return Color(int.parse(colorString, radix: 16));
}

// Background: #F5F9FF, Primary: #2C5BB1)
final Color kBackgroundColor = hexToColor('#F5F9FF');
final Color kPrimaryBlue = hexToColor('#2C5BB1'); // Used for icons/buttons

// --- Main Entry Point ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_test.dart'; // 👈 import the test file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Replace with your actual Firebase initialization if needed
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  } catch (e) {
    // Handle initialization error
  }

  runApp(const MyApp());
}

// --- App Root Widget ---

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style Her App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryBlue,
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // Start directly on the new navigation screen
      home: const MainNavigationScreen(),
    );
  }
}

// --- New Main Navigation Screen (Manages Bottom Bar) ---

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of screens to be displayed in the body of the Scaffold
  final List<Widget> _screens = [
    // Placeholder for a proper home screen (currently showing courses)
    const PopularCoursesScreen(),
    const TopMentorsScreen(),
    const NotificationsScreen(),
    // Placeholder for two more typical navigation items (e.g., Profile, Search)
    const Center(child: Text('Placeholder Screen 4 (e.g., Search)')),
    const Center(child: Text('Placeholder Screen 5 (e.g., Profile)')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The current screen is displayed here
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Courses', // Mapped to PopularCoursesScreen
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Mentors', // Mapped to TopMentorsScreen
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts', // Mapped to NotificationsScreen
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search', // Placeholder
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile', // Placeholder
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryBlue, // Use the primary blue color
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // Keep labels visible
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed, // Important for more than 3 items
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style Her App')),
      body: const Center(
        child: Text(
          'Welcome to Style Her — Firestore test ran successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}