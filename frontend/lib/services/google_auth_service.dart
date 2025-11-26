/**
 * Google Authentication Service
 * 
 * Handles Google Sign-In integration with Firebase Authentication
 */

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class GoogleAuthService {
  // Google Sign-In instance with email and profile scopes
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  /// Sign in with Google account
  /// Returns UserCredential on success, throws exception on failure
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In flow (opens Google account picker)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Step 2: Check if user cancelled the sign-in
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }
      
      // Step 3: Get authentication tokens from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Step 4: Create Firebase credential from Google tokens
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Step 5: Sign in to Firebase with Google credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific authentication errors
      throw Exception('Firebase Auth Error: ${e.message}');
    } catch (e) {
      // Handle other errors (network, Google Sign-In failures, etc.)
      throw Exception('Google Sign-In Error: $e');
    }
  }
  
  /// Sign out from both Google and Firebase
  static Future<void> signOut() async {
    await _googleSignIn.signOut(); // Sign out from Google
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
  }
}