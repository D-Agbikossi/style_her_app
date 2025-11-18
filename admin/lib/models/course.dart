import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Course Model
 * 
 * Represents a course with all its properties including title, description,
 * category, difficulty level, instructor information, pricing, and metadata.
 * This model is shared with the frontend app.
 */
class Course {
  /**
   * Unique course identifier
   */
  final String id;
  
  /**
   * Course title
   */
  final String title;
  
  /**
   * Course description
   */
  final String description;
  
  /**
   * Course category (e.g., "Make Up", "Hair Styling", "Arts")
   */
  final String category;
  
  /**
   * Difficulty level (e.g., "Beginner", "Intermediate", "Advanced")
   */
  final String difficulty;
  
  /**
   * Instructor name
   */
  final String instructor;
  
  /**
   * URL for course thumbnail image
   */
  final String thumbnailUrl;
  
  /**
   * Course duration in minutes
   */
  final int duration;
  
  /**
   * Number of lessons in the course
   */
  final int lessonCount;
  
  /**
   * Course rating (0-5 stars)
   */
  final double rating;
  
  /**
   * Number of enrolled students
   */
  final int enrolledCount;
  
  /**
   * Whether the course is free
   */
  final bool isFree;
  
  /**
   * Course price (null if free)
   */
  final double? price;
  
  /**
   * Course creation timestamp
   */
  final DateTime createdAt;
  
  /**
   * Course last update timestamp
   */
  final DateTime updatedAt;

  /**
   * Course constructor
   * 
   * Creates a new Course instance with all required properties
   */
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.instructor,
    required this.thumbnailUrl,
    required this.duration,
    required this.lessonCount,
    required this.rating,
    required this.enrolledCount,
    required this.isFree,
    this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  /**
   * Create Course from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return Course instance
   */
  factory Course.fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      difficulty: data['difficulty'] ?? 'Beginner',
      instructor: data['instructor'] ?? 'Unknown',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      duration: data['duration'] ?? 0,
      lessonCount: data['lessonCount'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      enrolledCount: data['enrolledCount'] ?? 0,
      isFree: data['isFree'] ?? true,
      price: data['price']?.toDouble(),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : (data['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : (data['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

  /**
   * Convert Course to Firestore document data
   * 
   * @return Map of course properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'instructor': instructor,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'lessonCount': lessonCount,
      'rating': rating,
      'enrolledCount': enrolledCount,
      'isFree': isFree,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

