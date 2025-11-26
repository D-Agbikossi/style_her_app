/**
 * Profile Screen - User Profile
 * 
 * This screen displays the user's profile with:
 * - User profile picture and name
 * - Menu items: My Courses, My Mentors, Notifications, Payment, Settings, Help Center, Logout
 * - Navigation to various profile-related screens
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes.dart';
import 'package:frontend/blocs/auth_bloc.dart';
import 'edit_profile.dart';
import '../widgets/profile_picture_widget.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1); // Main brand blue
const Color kBackgroundColor = Color(0xFFF5F9FF); // App background color

/**
 * ProfileScreen - Displays user profile and menu options
 */
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthBloc>(context);
    final user = authProvider.user;
    final profile = authProvider.profile;

    // Get user display name
    final displayName = profile?.displayName ?? 
                       user?.displayName ?? 
                       user?.email?.split('@')[0] ?? 
                       'User';

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Picture and Name
          Center(
            child: Column(
              children: [
                ProfilePictureWidget(
                  imageUrl: profile?.photoUrl ?? user?.photoURL,
                  radius: 50,
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey.withOpacity(0.3),
                  borderWidth: 2,
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (user?.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user!.email!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Items
          _buildMenuItem(
            context,
            icon: Icons.book_outlined,
            title: "My Courses",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.myCourses);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.people_outline,
            title: "My Mentors",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.topMentors);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.notifications_outlined,
            title: "Notifications",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.payment_outlined,
            title: "Payment",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.payment);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: "Settings",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: "Help Center",
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.helpCenter);
            },
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            titleColor: Colors.red,
            onTap: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /**
   * Build a menu item widget
   */
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? kPrimaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: titleColor ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

