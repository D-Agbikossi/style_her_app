/**
 * StyleHer - Beauty Learning Platform
 *
 * Main entry point for the StyleHer Flutter app.
 * Features:
 * - User authentication
 * - Course browsing
 * - Mentorship connections
 * - Notifications and job opportunities
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Local imports
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'routes.dart';
import 'screens/onboarding_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/popular_courses_screen.dart';
import 'screens/top_mentors_screen.dart';
import 'screens/mentor_info_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/courses_completed_screen.dart';
import 'screens/course_certification_screen.dart';

/// Convert a hex color code to [Color]
Color hexToColor(String hexCode) {
  String colorString = 'FF${hexCode.substring(1)}';
  return Color(int.parse(colorString, radix: 16));
}

// --- Global Colors ---
final Color kBackgroundColor = hexToColor('#F5F9FF');
final Color kPrimaryBlue = hexToColor('#2C5BB1');

/// --- APP ENTRY POINT ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

/// --- ROOT WIDGET ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StyleHer',
        theme: ThemeData(
          primaryColor: kPrimaryBlue,
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          fontFamily: 'Roboto',
        ),
        home: const AuthOrOnboarding(),
      ),
    );
  }

class AuthOrOnboarding extends StatelessWidget {
=======
/**
 * Authentication decision widget
 * Determines whether to show onboarding or main app based on user login status
 */
class AuthOrOnboarding extends StatefulWidget {
>>>>>>> origin/main
  const AuthOrOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, go to main navigation
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        } else {
          // Otherwise show onboarding
          return const OnboardingScreen();
        }
      },
    );
  }
}

/// --- MAIN NAVIGATION SCREEN ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<AuthOrOnboarding> createState() => _AuthOrOnboardingState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PopularCoursesScreen(),
    const TopMentorsScreen(),
    const NotificationsScreen(),
    const Center(child: Text('Search Screen Placeholder')),
    const Center(child: Text('Profile Screen Placeholder')),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Mentors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
    return const HomeScreen();
  }
}