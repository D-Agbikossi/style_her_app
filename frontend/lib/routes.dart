import 'package:flutter/material.dart';

import 'screens/notifications_screen.dart';
import 'screens/popular_courses_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/interest_screen.dart';
import 'screens/login_screen.dart';
import 'screens/my_courses_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/top_mentors_screen.dart';

class AppRoutes {
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/verify-email';
  static const String interest = '/interest';
  static const String home = '/home';
  static const String myCourses = '/my-courses';
  static const String popularCourses = '/popular-courses';
  static const String topMentors = '/top-mentors';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return _buildRoute(
          settings,
          const OnboardingScreen(),
        );
      case onboarding:
        return _buildRoute(
          settings,
          const OnboardingScreen(),
        );
      case signup:
        return _buildRoute(
          settings,
          const SignUpScreen(),
        );
      case login:
        return _buildRoute(
          settings,
          const LoginScreen(),
        );
      case forgotPassword:
        return _buildRoute(
          settings,
          const ForgotPasswordScreen(),
        );
      case emailVerification:
        return _buildRoute(
          settings,
          const EmailVerificationScreen(),
        );
      case interest:
        return _buildRoute(
          settings,
          const InterestScreen(),
        );
      case home:
        return _buildRoute(
          settings,
          const HomeScreen(),
        );
      case myCourses:
        return _buildRoute(
          settings,
          const MyCoursesScreen(),
        );
      case popularCourses:
        return _buildRoute(
          settings,
          const PopularCoursesScreen(),
        );
      case topMentors:
        return _buildRoute(
          settings,
          const TopMentorsScreen(),
        );
      case notifications:
        return _buildRoute(
          settings,
          const NotificationsScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => child,
    );
  }
}

