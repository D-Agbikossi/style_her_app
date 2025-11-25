/**
 * Authentication Provider
 * 
 * Manages user authentication state and user profile data.
 * Provides methods for sign-in, sign-up, sign-out, and password reset.
 * Listens to authentication state changes and user profile updates.
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  // Service dependencies for authentication and data storage
  final AuthService _authService;
  final FirestoreService _firestore;

  // Current authentication and profile state
  User? _firebaseUser; // Firebase authentication user
  UserProfile? _profile; // User profile data from Firestore
  StreamSubscription<User?>? _authSub; // Auth state subscription
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _profileSub; // Profile data subscription

  /**
   * Constructor - Initialize provider and start listening to auth changes
   * Allows dependency injection for testing
   */
  AuthProvider({AuthService? authService, FirestoreService? firestore})
    : _authService = authService ?? AuthService(),
      _firestore = firestore ?? FirestoreService() {
    // Listen to authentication state changes
    _authSub = _authService.authStateChanges().listen(_onAuthChange);
  }

  // Getters for current authentication state
  User? get user => _firebaseUser; // Current Firebase user
  UserProfile? get profile => _profile; // Current user profile
  bool get isAuthenticated => _firebaseUser != null; // User logged in status
  bool get isEmailVerified =>
      _firebaseUser?.emailVerified ?? false; // Email verification status

  /**
   * Sign in with email and password
   * Delegates to AuthService for Firebase authentication
   */
  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  /**
   * Sign up new user with email and password
   * Creates user account, sets up profile in Firestore, and sends verification email
   */
  Future<void> signUp(
    String email,
    String password, {
    String? displayName,
  }) async {
    // Create user account with Firebase Auth
    final cred = await _authService.signUpWithEmail(email, password);

    // Create user profile in Firestore
    await _firestore.createOrUpdateUser(cred.user!.uid, {
      'email': email,
      if (displayName != null) 'displayName': displayName,
    });

    // Send email verification
    await _authService.sendEmailVerification();
  }

  /**
   * Sign out current user
   * Clears authentication state and profile data
   */
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /**
   * Send password reset email
   * Delegates to AuthService for Firebase password reset functionality
   */
  Future<void> resetPassword(String email) =>
      _authService.sendPasswordResetEmail(email);

  /**
   * Resend email verification
   * Sends verification email to current user
   */
  Future<void> resendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  /**
   * Handle authentication state changes
   * Updates user state and manages profile data subscription
   */
  void _onAuthChange(User? user) {
    _firebaseUser = user;
    _profile = null;
    _profileSub?.cancel();

    if (user != null) {
      // User logged in - start listening to profile changes
      _profileSub = _firestore.watchUser(user.uid).listen((doc) {
        _profile = UserProfile.fromMap(user.uid, doc.data());
        notifyListeners();
      });
    } else {
      // User logged out - notify listeners
      notifyListeners();
    }
  }

  /**
   * Clean up resources when provider is disposed
   * Cancels all active subscriptions
   */
  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
