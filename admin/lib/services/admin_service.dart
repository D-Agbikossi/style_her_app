/**
 * Admin Service
 * 
 * Centralized service for all admin CRUD operations
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/course.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== COURSE OPERATIONS ==========

  Future<String> createCourse(Map<String, dynamic> courseData) async {
    try {
      final docRef = await _firestore.collection('courses').add({
        ...courseData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'enrolledCount': 0,
        'rating': 0.0,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<void> updateCourse(String courseId, Map<String, dynamic> courseData) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        ...courseData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  Stream<QuerySnapshot> getCoursesStream() {
    return _firestore.collection('courses').orderBy('createdAt', descending: true).snapshots();
  }

  Future<List<Course>> getCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();
      return snapshot.docs.map((doc) {
        return Course.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // ========== MENTOR OPERATIONS ==========

  Future<String> createMentor({
    required String email,
    required String password,
    required String displayName,
    required String specialty,
  }) async {
    try {
      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Failed to create user');

      final now = FieldValue.serverTimestamp();
      
      // Create mentor document in main users collection
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': displayName,
        'role': 'mentor',
        'specialty': specialty,
        'status': 'active',
        'videoCount': 0,
        'createdAt': now,
        'updatedAt': now,
      });

      // Also add to mentors subcollection for organized querying
      await _firestore
          .collection('users')
          .doc('_roles')
          .collection('mentors')
          .doc(user.uid)
          .set({
        'email': email,
        'displayName': displayName,
        'specialty': specialty,
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });

      return user.uid;
    } catch (e) {
      throw Exception('Failed to create mentor: $e');
    }
  }

  Future<void> updateMentor(String mentorId, Map<String, dynamic> data) async {
    try {
      final updateData = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Update main user document
      await _firestore.collection('users').doc(mentorId).update(updateData);
      
      // Update mentors subcollection
      await _firestore
          .collection('users')
          .doc('_roles')
          .collection('mentors')
          .doc(mentorId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update mentor: $e');
    }
  }

  Future<void> deleteMentor(String mentorId) async {
    try {
      // Delete from main users collection
      await _firestore.collection('users').doc(mentorId).delete();
      
      // Delete from mentors subcollection
      await _firestore
          .collection('users')
          .doc('_roles')
          .collection('mentors')
          .doc(mentorId)
          .delete();
      
      // Note: Firebase Auth user deletion should be done separately if needed
    } catch (e) {
      throw Exception('Failed to delete mentor: $e');
    }
  }

  Stream<QuerySnapshot> getMentorsStream() {
    // Query from mentors subcollection for better organization
    return _firestore
        .collection('users')
        .doc('_roles')
        .collection('mentors')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ========== USER OPERATIONS ==========

  Future<void> updateUserStatus(String userId, String status) async {
    try {
      final updateData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Update main user document
      await _firestore.collection('users').doc(userId).update(updateData);
      
      // Get user role to update correct subcollection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final role = userDoc.data()?['role'] as String?;
      
      if (role == 'learner') {
        await _firestore
            .collection('users')
            .doc('_roles')
            .collection('learners')
            .doc(userId)
            .update(updateData);
      } else if (role == 'mentor') {
        await _firestore
            .collection('users')
            .doc('_roles')
            .collection('mentors')
            .doc(userId)
            .update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // Get user role before deleting
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final role = userDoc.data()?['role'] as String?;
      
      // Delete from main users collection
      await _firestore.collection('users').doc(userId).delete();
      
      // Delete from appropriate subcollection
      if (role == 'learner') {
        await _firestore
            .collection('users')
            .doc('_roles')
            .collection('learners')
            .doc(userId)
            .delete();
      } else if (role == 'mentor') {
        await _firestore
            .collection('users')
            .doc('_roles')
            .collection('mentors')
            .doc(userId)
            .delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    // Get learners from learners subcollection
    return _firestore
        .collection('users')
        .doc('_roles')
        .collection('learners')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Helper method to create learner user
  Future<String> createLearner({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Failed to create user');

      final now = FieldValue.serverTimestamp();
      
      // Create learner document in main users collection
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': displayName,
        'role': 'learner',
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });

      // Also add to learners subcollection
      await _firestore
          .collection('users')
          .doc('_roles')
          .collection('learners')
          .doc(user.uid)
          .set({
        'email': email,
        'displayName': displayName,
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });

      return user.uid;
    } catch (e) {
      throw Exception('Failed to create learner: $e');
    }
  }

  // ========== CATEGORY OPERATIONS ==========

  Future<String> createCategory(String name) async {
    try {
      final docRef = await _firestore.collection('categories').add({
        'name': name,
        'courseCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  Future<void> updateCategory(String categoryId, String name) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'name': name,
      });
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  Stream<QuerySnapshot> getCategoriesStream() {
    return _firestore.collection('categories').snapshots();
  }

  Future<List<String>> getCategoryNames() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) => (doc.data()['name'] ?? '').toString())
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ========== BULK OPERATIONS ==========

  /**
   * Delete multiple courses
   * 
   * @param courseIds List of course IDs to delete
   * @return Number of successfully deleted courses
   */
  Future<int> bulkDeleteCourses(List<String> courseIds) async {
    int successCount = 0;
    for (var courseId in courseIds) {
      try {
        await deleteCourse(courseId);
        successCount++;
      } catch (e) {
        // Continue with other deletions even if one fails
      }
    }
    return successCount;
  }

  /**
   * Delete multiple mentors
   * 
   * @param mentorIds List of mentor IDs to delete
   * @return Number of successfully deleted mentors
   */
  Future<int> bulkDeleteMentors(List<String> mentorIds) async {
    int successCount = 0;
    for (var mentorId in mentorIds) {
      try {
        await deleteMentor(mentorId);
        successCount++;
      } catch (e) {
        // Continue with other deletions even if one fails
      }
    }
    return successCount;
  }

  /**
   * Delete multiple users
   * 
   * @param userIds List of user IDs to delete
   * @return Number of successfully deleted users
   */
  Future<int> bulkDeleteUsers(List<String> userIds) async {
    int successCount = 0;
    for (var userId in userIds) {
      try {
        await deleteUser(userId);
        successCount++;
      } catch (e) {
        // Continue with other deletions even if one fails
      }
    }
    return successCount;
  }

  /**
   * Update status for multiple users
   * 
   * @param userIds List of user IDs
   * @param status New status to set
   * @return Number of successfully updated users
   */
  Future<int> bulkUpdateUserStatus(List<String> userIds, String status) async {
    int successCount = 0;
    for (var userId in userIds) {
      try {
        await updateUserStatus(userId, status);
        successCount++;
      } catch (e) {
        // Continue with other updates even if one fails
      }
    }
    return successCount;
  }

  /**
   * Delete multiple categories
   * 
   * @param categoryIds List of category IDs to delete
   * @return Number of successfully deleted categories
   */
  Future<int> bulkDeleteCategories(List<String> categoryIds) async {
    int successCount = 0;
    for (var categoryId in categoryIds) {
      try {
        await deleteCategory(categoryId);
        successCount++;
      } catch (e) {
        // Continue with other deletions even if one fails
      }
    }
    return successCount;
  }

  // ========== STATS OPERATIONS ==========

  Future<Map<String, int>> getStats() async {
    try {
      // Get counts from subcollections for better organization
      final learners = await _firestore
          .collection('users')
          .doc('_roles')
          .collection('learners')
          .count()
          .get();

      final mentors = await _firestore
          .collection('users')
          .doc('_roles')
          .collection('mentors')
          .count()
          .get();

      final courses = await _firestore.collection('courses').count().get();

      return {
        'learners': learners.count ?? 0,
        'mentors': mentors.count ?? 0,
        'totalUsers': (learners.count ?? 0) + (mentors.count ?? 0),
        'courses': courses.count ?? 0,
      };
    } catch (e) {
      return {'learners': 0, 'mentors': 0, 'totalUsers': 0, 'courses': 0};
    }
  }
}

