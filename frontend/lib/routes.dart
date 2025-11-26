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
import 'screens/mentor_info_screen.dart';
import 'screens/course_detail_screen.dart';
// 🌟 IMPORT THE CERTIFICATE SCREEN 🌟
import 'screens/course_certification_screen.dart';
// 🌟 IMPORT THE CURRICULUM DETAIL SCREEN 🌟
import 'screens/curriculum_detail.dart';
import 'screens/payment_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_center_screen.dart';

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
  static const String mentorProfile = '/mentor-profile';
  static const String courseDetail = '/course-detail';
  // FIX: ADD MISSING CERTIFICATE ROUTE CONSTANT
  static const String certificate = '/certificate';
  static const String inbox = '/inbox';
  static const String marketplace = '/marketplace';
  static const String profile = '/profile';
  // 🌟 FIX: ADD MISSING CURRICULUM DETAIL ROUTE CONSTANT 🌟
  static const String curriculumDetail = '/curriculum-detail';
  static const String payment = '/payment';
  static const String settings = '/settings';
  static const String helpCenter = '/help-center';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case root:
        return _buildRoute(routeSettings, const OnboardingScreen());
      case onboarding:
        return _buildRoute(routeSettings, const OnboardingScreen());
      case signup:
        return _buildRoute(routeSettings, const SignUpScreen());
      case login:
        return _buildRoute(routeSettings, const LoginScreen());
      case forgotPassword:
        return _buildRoute(routeSettings, const ForgotPasswordScreen());
      case emailVerification:
        return _buildRoute(routeSettings, const EmailVerificationScreen());
      case interest:
        return _buildRoute(routeSettings, const InterestScreen());
      case home:
        return _buildRoute(routeSettings, const HomeScreen());
      case myCourses:
        return _buildRoute(routeSettings, const MyCoursesScreen());
      case popularCourses:
        return _buildRoute(routeSettings, const PopularCoursesScreen());
      case topMentors:
        return _buildRoute(routeSettings, const TopMentorsScreen());
      case notifications:
        return _buildRoute(routeSettings, const NotificationsScreen());

      case mentorProfile:
        if (args is String) {
          return _buildRoute(routeSettings, MentorProfileScreen(mentorId: args));
        }
        return _buildRoute(
          routeSettings,
          const Scaffold(body: Center(child: Text('Mentor ID missing'))),
        );

      case courseDetail:
        if (args is String) {
          return _buildRoute(routeSettings, CourseDetailsScreen(courseId: args));
        }
        return _buildRoute(
          routeSettings,
          const Scaffold(body: Center(child: Text('Course ID missing'))),
        );

      // FIX: ADD CERTIFICATE ROUTE HANDLER
      case certificate:
        if (args is String) {
          // NOTE: We hardcode 'Alex' for recipientName since we don't have user data here.
          return _buildRoute(
            routeSettings,
            CertificateScreen(courseId: args, recipientName: 'Alex'),
          );
        }
        return _buildRoute(
          routeSettings,
          const Scaffold(body: Center(child: Text('Certificate ID missing'))),
        );

      // 🌟 ADD CURRICULUM DETAIL ROUTE HANDLER 🌟
      case curriculumDetail:
        if (args is String) {
          // Pass the course ID to the curriculum screen
          return _buildRoute(routeSettings, CurriculumDetailScreen(courseId: args));
        }
        return _buildRoute(
          routeSettings,
          const Scaffold(body: Center(child: Text('Curriculum ID missing'))),
        );

      case payment:
        return _buildRoute(routeSettings, const PaymentScreen());

      case settings:
        return _buildRoute(routeSettings, const SettingsScreen());

      case helpCenter:
        return _buildRoute(routeSettings, const HelpCenterScreen());

      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${routeSettings.name} not found')),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings routeSettings,
    Widget child,
  ) {
    return MaterialPageRoute(settings: routeSettings, builder: (_) => child);
  }
}
