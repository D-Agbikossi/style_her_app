/**
 * Admin Setup Service
 * 
 * Helper service to register admin users in Firebase.
 * This should be run once to set up the first admin user.
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSetupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /**
   * Register a new admin user
   * 
   * Steps:
   * 1. Create user in Firebase Auth
   * 2. Create user document in Firestore with role: 'admin'
   * 
   * @param email Admin email address
   * @param password Admin password
   * @param displayName Admin display name
   * @return User ID if successful
   */
  Future<String> registerAdmin({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // 1. Create user in Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // 2. Update user profile
      await user.updateDisplayName(displayName);

      // 3. Create user document in Firestore with admin role
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': displayName,
        'role': 'admin', // This is the key field for admin access
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return user.uid;
    } catch (e) {
      rethrow;
    }
  }

  /**
   * Promote an existing user to admin
   * 
   * Use this if you already have a user account and want to make them admin
   * 
   * @param userId The Firebase Auth UID of the user
   * @return true if successful
   */
  Future<bool> promoteToAdmin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  /**
   * Check if a user is admin
   * 
   * @param userId The Firebase Auth UID of the user
   * @return true if user has admin role
   */
  Future<bool> isAdmin(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }
}

