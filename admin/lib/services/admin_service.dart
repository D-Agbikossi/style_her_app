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

      // Create mentor document
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': displayName,
        'role': 'mentor',
        'specialty': specialty,
        'status': 'active',
        'videoCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return user.uid;
    } catch (e) {
      throw Exception('Failed to create mentor: $e');
    }
  }

  Future<void> updateMentor(String mentorId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(mentorId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update mentor: $e');
    }
  }

  Future<void> deleteMentor(String mentorId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('users').doc(mentorId).delete();
      // Note: Firebase Auth user deletion should be done separately if needed
    } catch (e) {
      throw Exception('Failed to delete mentor: $e');
    }
  }

  Stream<QuerySnapshot> getMentorsStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'mentor')
        .snapshots();
  }

  // ========== USER OPERATIONS ==========

  Future<void> updateUserStatus(String userId, String status) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore
        .collection('users')
        .where('role', isNotEqualTo: 'admin')
        .snapshots();
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

  // ========== STATS OPERATIONS ==========

  Future<Map<String, int>> getStats() async {
    try {
      final users = await _firestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .count()
          .get();

      final mentors = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'mentor')
          .count()
          .get();

      final courses = await _firestore.collection('courses').count().get();

      return {
        'users': users.count ?? 0,
        'mentors': mentors.count ?? 0,
        'courses': courses.count ?? 0,
      };
    } catch (e) {
      return {'users': 0, 'mentors': 0, 'courses': 0};
    }
  }
}

