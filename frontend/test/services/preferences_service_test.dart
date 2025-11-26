/**
 * Preferences Service Unit Tests
 * 
 * Unit tests for PreferencesService
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService preferencesService;

    setUp(() {
      preferencesService = PreferencesService();
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('Dark Mode', () {
      test('should return default dark mode value (false)', () async {
        final darkMode = await preferencesService.getDarkMode();
        expect(darkMode, equals(false));
      });

      test('should save and retrieve dark mode preference', () async {
        await preferencesService.setDarkMode(true);
        final darkMode = await preferencesService.getDarkMode();
        expect(darkMode, equals(true));
      });
    });

    group('Language', () {
      test('should return default language (en)', () async {
        final language = await preferencesService.getLanguage();
        expect(language, equals('en'));
      });

      test('should save and retrieve language preference', () async {
        await preferencesService.setLanguage('fr');
        final language = await preferencesService.getLanguage();
        expect(language, equals('fr'));
      });
    });

    group('Notifications', () {
      test('should return default email notifications (true)', () async {
        final emailNotif = await preferencesService.getEmailNotifications();
        expect(emailNotif, equals(true));
      });

      test('should save and retrieve email notifications preference', () async {
        await preferencesService.setEmailNotifications(false);
        final emailNotif = await preferencesService.getEmailNotifications();
        expect(emailNotif, equals(false));
      });

      test('should return default push notifications (true)', () async {
        final pushNotif = await preferencesService.getPushNotifications();
        expect(pushNotif, equals(true));
      });

      test('should save and retrieve push notifications preference', () async {
        await preferencesService.setPushNotifications(false);
        final pushNotif = await preferencesService.getPushNotifications();
        expect(pushNotif, equals(false));
      });
    });

    group('Onboarding', () {
      test('should return default onboarding completed (false)', () async {
        final completed = await preferencesService.isOnboardingCompleted();
        expect(completed, equals(false));
      });

      test('should save and retrieve onboarding completion', () async {
        await preferencesService.setOnboardingCompleted(true);
        final completed = await preferencesService.isOnboardingCompleted();
        expect(completed, equals(true));
      });
    });
  });
}

