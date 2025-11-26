/**
 * Preferences Service
 * 
 * Manages user preferences using SharedPreferences
 * Handles theme, language, and notification preferences
 */

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Preference keys
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLanguage = 'language';
  static const String _keyEmailNotifications = 'email_notifications';
  static const String _keyPushNotifications = 'push_notifications';
  static const String _keyCourseUpdates = 'course_updates';
  static const String _keyMarketingEmails = 'marketing_emails';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  // Default values
  static const bool _defaultDarkMode = false;
  static const String _defaultLanguage = 'en';
  static const bool _defaultEmailNotifications = true;
  static const bool _defaultPushNotifications = true;
  static const bool _defaultCourseUpdates = true;
  static const bool _defaultMarketingEmails = false;
  static const bool _defaultOnboardingCompleted = false;

  /// Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // ========== THEME PREFERENCES ==========

  /// Get dark mode preference
  Future<bool> getDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDarkMode) ?? _defaultDarkMode;
  }

  /// Set dark mode preference
  Future<bool> setDarkMode(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyDarkMode, value);
  }

  // ========== LANGUAGE PREFERENCES ==========

  /// Get language preference
  Future<String> getLanguage() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLanguage) ?? _defaultLanguage;
  }

  /// Set language preference
  Future<bool> setLanguage(String languageCode) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyLanguage, languageCode);
  }

  // ========== NOTIFICATION PREFERENCES ==========

  /// Get email notifications preference
  Future<bool> getEmailNotifications() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyEmailNotifications) ?? _defaultEmailNotifications;
  }

  /// Set email notifications preference
  Future<bool> setEmailNotifications(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyEmailNotifications, value);
  }

  /// Get push notifications preference
  Future<bool> getPushNotifications() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyPushNotifications) ?? _defaultPushNotifications;
  }

  /// Set push notifications preference
  Future<bool> setPushNotifications(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyPushNotifications, value);
  }

  /// Get course updates preference
  Future<bool> getCourseUpdates() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyCourseUpdates) ?? _defaultCourseUpdates;
  }

  /// Set course updates preference
  Future<bool> setCourseUpdates(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyCourseUpdates, value);
  }

  /// Get marketing emails preference
  Future<bool> getMarketingEmails() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyMarketingEmails) ?? _defaultMarketingEmails;
  }

  /// Set marketing emails preference
  Future<bool> setMarketingEmails(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyMarketingEmails, value);
  }

  // ========== ONBOARDING PREFERENCE ==========

  /// Check if onboarding has been completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyOnboardingCompleted) ?? _defaultOnboardingCompleted;
  }

  /// Mark onboarding as completed
  Future<bool> setOnboardingCompleted(bool value) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyOnboardingCompleted, value);
  }

  // ========== UTILITY METHODS ==========

  /// Clear all preferences (for logout/testing)
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }

  /// Get all preferences as a map (for debugging)
  Future<Map<String, dynamic>> getAllPreferences() async {
    return {
      'darkMode': await getDarkMode(),
      'language': await getLanguage(),
      'emailNotifications': await getEmailNotifications(),
      'pushNotifications': await getPushNotifications(),
      'courseUpdates': await getCourseUpdates(),
      'marketingEmails': await getMarketingEmails(),
      'onboardingCompleted': await isOnboardingCompleted(),
    };
  }
}

