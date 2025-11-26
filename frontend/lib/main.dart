// Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'blocs/auth_bloc.dart';
import 'repositories/course_repository.dart';
import 'routes.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/preferences_service.dart';

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
  final PreferencesService _prefsService = PreferencesService();
  bool _isLoading = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  /// Check if onboarding has been completed
  Future<void> _checkOnboardingStatus() async {
    try {
      final isCompleted = await _prefsService.isOnboardingCompleted();
      setState(() {
        _showOnboarding = !isCompleted;
        _isLoading = false;
      });
    } catch (e) {
      // If check fails, show onboarding
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show onboarding if not completed, otherwise check auth state
    if (_showOnboarding) {
      return const OnboardingScreen();
    }

    // Check authentication state
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // User is logged in
          return const AuthWrapper();
        } else {
          // User is not logged in, go to login
          return const LoginScreen();
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
