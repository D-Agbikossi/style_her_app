/**
 * Mentor Service
 * 
 * Fetches mentor data from Firestore for the frontend app
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class MentorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get stream of all active mentors
  /// Uses main users collection to avoid composite index requirements
  Stream<QuerySnapshot> getMentorsStream() {
    // Query from main users collection (more reliable, no composite index needed)
    // Filter by role and status, then sort in memory if needed
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'mentor')
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  /// Get list of all active mentors
  /// Queries from main users collection (more reliable)
  Future<List<Map<String, dynamic>>> getMentors() async {
    try {
      // Query from main users collection (no composite index needed)
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'mentor')
          .where('status', isEqualTo: 'active')
          .get();

      final mentors = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['displayName'] ?? 'Unknown',
          'specialty': data['specialty'] ?? 'General',
          'email': data['email'] ?? '',
          'photoUrl': data['photoUrl'],
          'workplace': data['workplace'] ?? '',
          'bio': data['bio'] ?? '',
          'videoCount': data['videoCount'] ?? 0,
          'createdAt': data['createdAt'],
        };
      }).toList();

      // Sort by createdAt in memory (descending)
      mentors.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return mentors;
    } catch (e) {
      // Return empty list on error - error handling done at UI level
      return [];
    }
  }

  /// Get a single mentor by ID
  /// Checks both subcollection and main users collection
  Future<Map<String, dynamic>?> getMentorById(String mentorId) async {
    try {
      // Try main users collection first (more reliable)
      var doc = await _firestore
          .collection('users')
          .doc(mentorId)
          .get();

      if (!doc.exists) {
        // Fallback to subcollection
        doc = await _firestore
            .collection('users')
            .doc('_roles')
            .collection('mentors')
            .doc(mentorId)
            .get();
      }

      if (!doc.exists) return null;

      final data = doc.data()!;
      // Verify it's a mentor
      if (data['role'] != 'mentor' && data['role'] != null) {
        return null;
      }

      return {
        'id': doc.id,
        'name': data['displayName'] ?? 'Unknown',
        'specialty': data['specialty'] ?? 'General',
        'email': data['email'] ?? '',
        'photoUrl': data['photoUrl'],
        'workplace': data['workplace'] ?? '',
        'bio': data['bio'] ?? '',
        'videoCount': data['videoCount'] ?? 0,
        'createdAt': data['createdAt'],
      };
    } catch (e) {
      // Return null on error - error handling done at UI level
      return null;
    }
  }
}

