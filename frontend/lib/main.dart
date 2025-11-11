/**
 * StyleHer - Beauty Learning Platform
 * 
 * Main application entry point for the StyleHer Flutter app.
 * This app provides a platform for beauty professionals to learn,
 * connect with mentors, and find job opportunities.
 * 
 * Features:
 * - User authentication (login/signup/password reset)
 * - Course browsing and enrollment
 * - Community posts and interactions
 * - Job opportunities
 * 
 * Tech Stack:
 * - Flutter for cross-platform UI
 * - Firebase for backend services (Auth, Firestore, Storage)
 * - Provider for state management
 */

// Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';

// State management
import 'package:provider/provider.dart';

// App-specific imports
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/home_screen.dart';

/**
 * Application entry point
 * Initializes Firebase and runs the main app
 */

import 'services/firestore_test.dart'; // 👈 import the test file

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

Future<void> main() async {
  // Ensure Flutter binding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the main application
  runApp(const MyApp());
}

/**
 * App Color Scheme
 * Consistent color palette used throughout the application
 */
const Color kPrimaryColor = Color(0xFF6A88E3); // Main brand color (blue)
const Color kPrimaryText = Color(
  0xFF4A6FDB,
); // Primary text color (darker blue)
const Color kScaffoldBackground = Colors.white; // Background color for screens
=======
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
>>>>>>> Stashed changes

/**
 * Root widget of the StyleHer application
 * Sets up providers, theme, and initial routing
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Configure system UI (status bar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),

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

<<<<<<< Updated upstream
    // Set up providers for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CourseProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StyleHer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: kScaffoldBackground,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        home: const AuthOrOnboarding(), // Initial screen based on auth state
=======
// --- New Main Navigation Screen (Manages Bottom Bar) ---

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

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
>>>>>>> Stashed changes
      ),
    );
  }
}

<<<<<<< Updated upstream
/**
 * Authentication decision widget
 * Determines whether to show onboarding or main app based on user login status
 */
class AuthOrOnboarding extends StatelessWidget {
  const AuthOrOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          final user = snapshot.data!;
          // Check if email is verified
          if (!user.emailVerified) {
            return const EmailVerificationScreen();
          }
          return const AuthWrapper();
        } else {
          // User is not logged in - show onboarding
          return const OnboardingScreen();
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your real authenticated root (e.g., HomeScreen or a navigation scaffold)
    return Scaffold(
      appBar: AppBar(title: const Text('StyleHer')),
      body: const Center(child: Text('Welcome back!')),
=======
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
>>>>>>> Stashed changes
    );
  }
}
