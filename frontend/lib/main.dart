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
    );

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
      ),
    );
  }
}

/**
 * Authentication decision widget
 * Determines whether to show onboarding or main app based on user login status
 */
class AuthOrOnboarding extends StatefulWidget {
  const AuthOrOnboarding({super.key});

  @override
  State<AuthOrOnboarding> createState() => _AuthOrOnboardingState();
}

class _AuthOrOnboardingState extends State<AuthOrOnboarding> {
  @override
  void initState() {
    super.initState();
    // Uncomment the line below to force logout on app restart (for testing)
    FirebaseAuth.instance.signOut();
  }

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
    return const HomeScreen();
  }
}