import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _allCourses = [];
  List<Course> _popularCourses = [];
  bool _isLoading = false;

  List<Course> get allCourses => _allCourses;
  List<Course> get popularCourses => _popularCourses;
  bool get isLoading => _isLoading;

  Future<void> fetchAllCourses() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call with sample data
    await Future.delayed(const Duration(seconds: 1));
    
    _allCourses = [
      Course(
        id: '1',
        title: 'Complete Makeup Course',
        description: 'Learn professional makeup techniques',
        category: 'Make Up',
        difficulty: 'Beginner',
        rating: 4.8,
        lessonCount: 12,
        duration: 120,
        price: 99.99,
        isFree: false,
        thumbnailUrl: '',
        instructor: 'Precious',
        enrolledCount: 150,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: '2',
        title: 'Hair Styling Basics',
        description: 'Master the art of hair styling',
        category: 'Hair Styling',
        difficulty: 'Intermediate',
        rating: 4.6,
        lessonCount: 8,
        duration: 90,
        price: 79.99,
        isFree: false,
        thumbnailUrl: '',
        instructor: 'Brunelle',
        enrolledCount: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPopularCourses() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _popularCourses = _allCourses.where((course) => course.rating >= 4.5).toList();

    _isLoading = false;
    notifyListeners();
  }
}