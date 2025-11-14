// Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'routes.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';
import 'screens/email_verification_screen.dart';
import 'screens/home_screen.dart';

class StyleHerAppState extends StatefulWidget {
  const StyleHerAppState({super.key});

  @override
  State<StyleHerAppState> createState() => StyleHerAppStateState();
}

class StyleHerAppStateState extends State<StyleHerAppState> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
    );
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the main application
  runApp(const MyApp());
}


const Color kPrimaryColor = Color(0xFF6A88E3); // 
const Color kPrimaryText = Color(
  0xFF4A6FDB,
);
const Color kScaffoldBackground = Colors.white; // 
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
        onGenerateRoute: AppRoutes.generateRoute,
        home: const AuthOrOnboarding(), // Initial screen based on auth state
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
  State<AuthOrOnboarding> createState() => _AuthOrOnboardingState();
}

class _AuthOrOnboardingState extends State<AuthOrOnboarding> {
  @override
  void initState() {
    super.initState();
    // Uncomment the line below to force logout on app restart (for testing)
    // FirebaseAuth.instance.signOut();
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

    return Scaffold(
      appBar: AppBar(title: const Text('StyleHer')),
      body: const Center(child: Text('Welcome back!')),
    );
    return const HomeScreen();
  }
}