/**
 * Authentication Provider
 * 
 * This provider handles all Firebase authentication operations:
 * - User sign in with email/password
 * - User registration with email/password
 * - Email verification
 * - Password reset
 * - User sign out
 * - Authentication state monitoring
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /**
   * Stream of authentication state changes
   * Emits current user or null when auth state changes
   */
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /**
   * Get currently signed in user
   * Returns null if no user is signed in
   */
  User? get user => _auth.currentUser;
  User? get currentUser => _auth.currentUser;
  
  /**
   * Get user profile (placeholder for now)
   */
  dynamic get profile => null;

  /**
   * Sign in user with email and password
   * Returns UserCredential on success, throws error on failure
   */
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /**
   * Create new user account with email and password
   * Returns UserCredential on success, throws error on failure
   */
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /**
   * Sign up method expected by screens
   */
  Future<void> signUp(String email, String password, {String? displayName}) async {
    await signUpWithEmail(email, password);
    notifyListeners();
  }

  /**
   * Send email verification to current user
   * Only sends if user is not already verified
   */
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /**
   * Sign out current user
   * Clears authentication state
   */
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  /**
   * Send password reset email
   * Sends reset link to provided email address
   */
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
