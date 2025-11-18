import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/management_screen.dart';
import 'screens/video_screen.dart';
import 'screens/mentor_screen.dart';
import 'screens/user_screen.dart';
import 'screens/admin_setup_screen.dart';
import 'screens/add_edit_course_screen.dart';
import 'screens/add_edit_mentor_screen.dart';

// Model imports
import 'models/course.dart';

class AdminRoutes {
  static const String setup = '/admin/setup';
  static const String login = '/admin/login';
  static const String dashboard = '/admin/dashboard';
  static const String management = '/admin/management';
  static const String videos = '/admin/videos';
  static const String mentors = '/admin/mentors';
  static const String users = '/admin/users';
  static const String addCourse = '/admin/courses/add';
  static const String editCourse = '/admin/courses/edit';
  static const String addMentor = '/admin/mentors/add';
  static const String editMentor = '/admin/mentors/edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case setup:
        return _buildRoute(settings, const AdminSetupScreen());
      case login:
        return _buildRoute(settings, const AdminLoginScreen());
      case dashboard:
        return _buildRoute(settings, const AdminDashboardScreen());
      case management:
        return _buildRoute(settings, const ManagementScreen());
      case videos:
        return _buildRoute(settings, const VideoScreen());
      case mentors:
        return _buildRoute(settings, const MentorScreen());
      case users:
        return _buildRoute(settings, const UserScreen());
      case addCourse:
        return _buildRoute(settings, const AddEditCourseScreen());
      case editCourse:
        final course = settings.arguments as Course?;
        return _buildRoute(settings, AddEditCourseScreen(course: course));
      case addMentor:
        return _buildRoute(settings, const AddEditMentorScreen());
      case editMentor:
        final mentor = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(settings, AddEditMentorScreen(mentor: mentor));
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => child);
  }
}

