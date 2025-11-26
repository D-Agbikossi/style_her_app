import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
import '../constants/app_constants.dart';

/**
 * Course Provider
 * 
 * Manages course data from Firestore with real-time updates
 */
class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Course> _allCourses = [];
  List<Course> _popularCourses = [];
  Course? _currentCourse;
  bool _isLoading = false;
  String? _error;

  List<Course> get allCourses => _allCourses;
  List<Course> get popularCourses => _popularCourses;
  Course? get currentCourse => _currentCourse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /**
   * Fetch all courses from Firestore
   */
  Future<void> fetchAllCourses() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .orderBy('createdAt', descending: true)
          .get();

      _allCourses = snapshot.docs
          .map((doc) => Course.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load courses. Please check your connection and try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /**
   * Fetch popular courses (rating >= 4.5)
   * 
   * Strategy: Fetch more courses than needed, sort in memory, then take top N.
   * This avoids Firestore composite index requirement for rating + createdAt queries.
   */
  Future<void> fetchPopularCourses() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Fetch courses with rating >= 4.5, limit to maxSearchResults to avoid large queries
      final QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .where('rating', isGreaterThanOrEqualTo: AppConstants.minPopularRating)
          .limit(AppConstants.maxSearchResults)
          .get();

      // Sort by rating (descending) in memory, then take top N courses
      _popularCourses = snapshot.docs
          .map((doc) => Course.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.rating.compareTo(a.rating)) // Sort descending by rating
        ..take(AppConstants.popularCoursesLimit) // Take top N
        ..toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load popular courses. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /**
   * Fetch a single course by ID
   */
  Future<void> fetchCourseById(String courseId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final DocumentSnapshot doc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();

      if (doc.exists) {
        _currentCourse = Course.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      } else {
        _error = 'Course not found';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load course details. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /**
   * Stream courses for real-time updates
   */
  Stream<List<Course>> getCoursesStream() {
    return _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromMap(
                  doc.id,
                  doc.data(),
                ))
            .toList());
  }

  /**
   * Search courses by title, description, category, or instructor
   * Uses case-insensitive search for better results
   */
  Future<List<Course>> searchCourses(String query) async {
    if (query.isEmpty) return [];
    
    try {
      // Get all courses and filter in memory for better search
      // This allows searching in title, description, category, and instructor
      final QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .limit(AppConstants.maxSearchResults * 2) // Limit to prevent excessive data transfer
          .get();
      
      final queryLower = query.toLowerCase().trim();
      
      return snapshot.docs
          .map((doc) => Course.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .where((course) => 
              course.title.toLowerCase().contains(queryLower) ||
              course.description.toLowerCase().contains(queryLower) ||
              course.category.toLowerCase().contains(queryLower) ||
              course.instructor.toLowerCase().contains(queryLower)
          )
          .take(AppConstants.maxSearchResults) // Limit results
          .toList();
    } catch (e) {
      return [];
    }
  }

  /**
   * Get courses by category
   */
  Future<List<Course>> getCoursesByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Course.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }
}