/**
 * Firestore Service
 * 
 * This service handles all Firestore database operations:
 * - User profile CRUD operations
 * - User data management with timestamps
 * - Wardrobe subcollection management
 * - Real-time data streaming
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /**
   * Users collection reference
   * Main collection for user profile data
   */
  CollectionReference<Map<String, dynamic>> get users => _db.collection('users');

  /**
   * Create or update user profile
   * Merges new data with existing data and updates timestamp
   */
  Future<void> createOrUpdateUser(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /**
   * Get user document snapshot
   * Returns user data for given UID
   */
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return await users.doc(uid).get();
  }

  /**
   * Stream user document changes
   * Real-time updates for user profile data
   */
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) {
    return users.doc(uid).snapshots();
  }

  /**
   * Wardrobes subcollection reference
   * User's wardrobe items collection
   */
  CollectionReference<Map<String, dynamic>> wardrobes(String uid) => users.doc(uid).collection('wardrobes');

  /**
   * Add new wardrobe item
   * Creates document with server timestamps
   */
  Future<DocumentReference<Map<String, dynamic>>> addWardrobe(String uid, Map<String, dynamic> data) async {
    return await wardrobes(uid).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /**
   * Stream wardrobe items for user
   * Returns ordered list of wardrobe items by creation date
   */
  Stream<QuerySnapshot<Map<String, dynamic>>> watchWardrobes(String uid) {
    return wardrobes(uid).orderBy('createdAt', descending: true).snapshots();
  }
}
