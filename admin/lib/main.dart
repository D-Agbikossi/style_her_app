/**
 * StyleHer Admin Portal
 * 
 * Admin interface for managing courses, mentors, videos, and users.
 * Only accessible to users with admin role.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/admin_auth_provider.dart';
import 'routes.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin_setup_screen.dart';

// Color scheme matching frontend style
const Color kPrimaryColor = Color(0xFF6A88E3);
const Color kPrimaryText = Color(0xFF4A6FDB);
const Color kScaffoldBackground = Color(0xFFF5F9FF);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => AdminAuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StyleHer Admin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: kScaffoldBackground,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        onGenerateRoute: AdminRoutes.generateRoute,
        initialRoute: AdminRoutes.setup,
        home: const AdminAuthWrapper(),
      ),
    );
  }
}

class AdminAuthWrapper extends StatelessWidget {
  const AdminAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AdminAuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!authProvider.isAuthenticated || !authProvider.isAdmin) {
      // Check if any admin exists, if not show setup screen
      return const AdminSetupScreen();
    }

    return const AdminDashboardScreen();
  }
}
