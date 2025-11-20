/**
 * Enrollment Service
 * 
 * Handles course enrollment operations for users
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnrollmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /**
   * Enroll a user in a course
   * 
   * @param courseId The ID of the course to enroll in
   * @return True if enrollment successful, false otherwise
   */
  Future<bool> enrollInCourse(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to enroll');
      }

      final userId = user.uid;
      final now = FieldValue.serverTimestamp();

      // Check if already enrolled
      final enrollmentDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('enrollments')
          .doc(courseId)
          .get();

      if (enrollmentDoc.exists) {
        // Already enrolled
        return false;
      }

      // Create enrollment document
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('enrollments')
          .doc(courseId)
          .set({
        'courseId': courseId,
        'enrolledAt': now,
        'progress': 0.0,
        'completed': false,
        'lastAccessedAt': now,
        'videosWatched': <String>[],
      });

      // Update course enrollment count
      await _firestore
          .collection('courses')
          .doc(courseId)
          .update({
        'enrolledCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  /**
   * Check if user is enrolled in a course
   * 
   * @param courseId The course ID to check
   * @return True if enrolled, false otherwise
   */
  Future<bool> isEnrolled(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final enrollmentDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrollments')
          .doc(courseId)
          .get();

      return enrollmentDoc.exists;
    } catch (e) {
      return false;
    }
  }

  /**
   * Get user's enrolled courses
   * 
   * @return List of course IDs the user is enrolled in
   */
  Future<List<String>> getEnrolledCourses() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrollments')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  /**
   * Update video watch progress
   * 
   * @param courseId The course ID
   * @param videoUrl The video URL that was watched
   * @param progress Progress percentage (0.0 to 1.0)
   */
  Future<void> updateVideoProgress(
    String courseId,
    String videoUrl,
    double progress,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final enrollmentRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrollments')
          .doc(courseId);

      final enrollmentDoc = await enrollmentRef.get();
      if (!enrollmentDoc.exists) return;

      final data = enrollmentDoc.data()!;
      final videosWatched = List<String>.from(data['videosWatched'] ?? []);

      // Add video to watched list if not already there
      if (!videosWatched.contains(videoUrl)) {
        videosWatched.add(videoUrl);
      }

      // Calculate overall progress
      final courseDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();
      
      final courseData = courseDoc.data();
      final totalVideos = (courseData?['videoUrls'] as List?)?.length ?? 1;
      final overallProgress = videosWatched.length / totalVideos;

      // Update enrollment
      await enrollmentRef.update({
        'videosWatched': videosWatched,
        'progress': overallProgress,
        'lastAccessedAt': FieldValue.serverTimestamp(),
        'completed': overallProgress >= 1.0,
      });
    } catch (e) {
      // Silently fail - progress tracking is not critical
      print('Error updating video progress: $e');
    }
  }

  /**
   * Unenroll from a course
   * 
   * @param courseId The course ID to unenroll from
   */
  Future<void> unenrollFromCourse(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('enrollments')
          .doc(courseId)
          .delete();

      // Decrement enrollment count
      await _firestore
          .collection('courses')
          .doc(courseId)
          .update({
        'enrolledCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Failed to unenroll from course: $e');
    }
  }
}

