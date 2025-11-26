// Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'blocs/auth_bloc.dart';
import 'repositories/course_repository.dart';
import 'routes.dart';
import 'screens/onboarding_screen.dart';
import 'theme_cubit.dart';
import 'screens/email_verification_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the main application
  runApp(const MyApp());
}

const Color kPrimaryColor = Color(0xFF6A88E3);
const Color kPrimaryText = Color(0xFF4A6FDB);
const Color kScaffoldBackground = Colors.white;

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
        ChangeNotifierProvider(create: (_) => AuthBloc()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
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
}

class AuthOrOnboarding extends StatefulWidget {
  const AuthOrOnboarding({super.key});

  @override
  State<AuthOrOnboarding> createState() => _AuthOrOnboardingState();
}

class _AuthOrOnboardingState extends State<AuthOrOnboarding> {
  @override
  void initState() {
    super.initState();
    // Clear all cached authentication data
    _clearAuthCache();
  }

  Future<void> _clearAuthCache() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Always show onboarding screen - no auto-login
    return const OnboardingScreen();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
