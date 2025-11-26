/**
 * Settings Screen
 * 
 * This screen displays app settings including:
 * - Account settings
 * - Notification preferences
 * - Privacy settings
 * - App preferences
 */

import 'package:flutter/material.dart';
import 'edit_profile.dart';
import '../services/preferences_service.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1);
const Color kBackgroundColor = Color(0xFFF5F9FF);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _prefsService = PreferencesService();
  
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _courseUpdates = true;
  bool _marketingEmails = false;
  bool _darkMode = false;
  String _language = 'English (US)';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Load all preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    try {
      final darkMode = await _prefsService.getDarkMode();
      final language = await _prefsService.getLanguage();
      final emailNotif = await _prefsService.getEmailNotifications();
      final pushNotif = await _prefsService.getPushNotifications();
      final courseUpdates = await _prefsService.getCourseUpdates();
      final marketingEmails = await _prefsService.getMarketingEmails();

      setState(() {
        _darkMode = darkMode;
        _language = language == 'en' ? 'English (US)' : language == 'fr' ? 'French' : 'English (US)';
        _emailNotifications = emailNotif;
        _pushNotifications = pushNotif;
        _courseUpdates = courseUpdates;
        _marketingEmails = marketingEmails;
        _isLoading = false;
      });
    } catch (e) {
      // If loading fails, use defaults
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Account Settings Section
          _buildSectionHeader('Account'),
          const SizedBox(height: 12),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password change coming soon')),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.email_outlined,
            title: 'Email Settings',
            subtitle: 'Manage your email preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email settings coming soon')),
              );
            },
          ),

          const SizedBox(height: 32),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          const SizedBox(height: 12),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotifications,
            onChanged: (value) async {
              setState(() {
                _emailNotifications = value;
              });
              // Save to SharedPreferences
              await _prefsService.setEmailNotifications(value);
            },
          ),
          const SizedBox(height: 8),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: _pushNotifications,
            onChanged: (value) async {
              setState(() {
                _pushNotifications = value;
              });
              // Save to SharedPreferences
              await _prefsService.setPushNotifications(value);
            },
          ),
          const SizedBox(height: 8),
          _buildSwitchTile(
            icon: Icons.school_outlined,
            title: 'Course Updates',
            subtitle: 'Get notified about new courses',
            value: _courseUpdates,
            onChanged: (value) async {
              setState(() {
                _courseUpdates = value;
              });
              // Save to SharedPreferences
              await _prefsService.setCourseUpdates(value);
            },
          ),
          const SizedBox(height: 8),
          _buildSwitchTile(
            icon: Icons.campaign_outlined,
            title: 'Marketing Emails',
            subtitle: 'Receive promotional emails',
            value: _marketingEmails,
            onChanged: (value) async {
              setState(() {
                _marketingEmails = value;
              });
              // Save to SharedPreferences
              await _prefsService.setMarketingEmails(value);
            },
          ),

          const SizedBox(height: 32),

          // Privacy Section
          _buildSectionHeader('Privacy & Security'),
          const SizedBox(height: 12),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy coming soon')),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            title: 'Security',
            subtitle: 'Manage your account security',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Security settings coming soon')),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            titleColor: Colors.red,
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),

          const SizedBox(height: 32),

          // App Preferences Section
          _buildSectionHeader('App Preferences'),
          const SizedBox(height: 12),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (value) async {
              setState(() {
                _darkMode = value;
              });
              // Save to SharedPreferences
              await _prefsService.setDarkMode(value);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? 'Dark mode enabled' : 'Dark mode disabled'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: _language,
            onTap: () {
              _showLanguageDialog();
            },
          ),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader('About'),
          const SizedBox(height: 12),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: null,
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of service coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Container(
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: titleColor ?? kPrimaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: titleColor ?? Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kPrimaryColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: kPrimaryColor,
        ),
      ),
    );
  }

  /// Show language selection dialog
  void _showLanguageDialog() {
    final languages = [
      {'code': 'en', 'name': 'English (US)'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'es', 'name': 'Spanish'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = _language == lang['name'];
            return ListTile(
              title: Text(lang['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: kPrimaryColor)
                  : null,
              onTap: () async {
                Navigator.of(context).pop();
                final languageCode = lang['code']!;
                final languageName = lang['name']!;
                await _prefsService.setLanguage(languageCode);
                if (!mounted) return;
                setState(() {
                  _language = languageName;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to ${lang['name']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion coming soon')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

