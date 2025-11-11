/**
 * User Progress Model
 * 
 * Represents a user's progress for a specific lesson within a course.
 * Tracks completion status and percentage for individual lessons.
 * Used for storing and retrieving user progress data from Firestore.
 */
class UserProgress {
/**
   * Progress entry unique identifier
   */
  final String id;

  /**
   * User ID this progress belongs to
   */
  final String userId;

  /**
   * Course ID this progress belongs to
   */
  final String courseId;

  /**
   * Lesson ID this progress belongs to
   */
  final String lessonId;

  /**
   * Whether the lesson is completed (100% completion)
   */
  final bool isCompleted;

  /**
   * Completion percentage (0.0 to 100.0)
   */
  final double completionPercentage;

  /**
   * Timestamp when lesson was completed (optional)
   */
  final DateTime? completedAt;

  /**
   * Progress entry creation timestamp
   */
  final DateTime createdAt;

  /**
   * Progress entry last update timestamp
   */
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.lessonId,
    required this.isCompleted,
    required this.completionPercentage,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

/**
   * Create UserProgress from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return UserProgress instance
   */
  factory UserProgress.fromMap(String id, Map<String, dynamic> data) {
    return UserProgress(
      id: id,
      userId: data['userId'] ?? '',
      courseId: data['courseId'] ?? '',
      lessonId: data['lessonId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      completionPercentage: (data['completionPercentage'] ?? 0.0).toDouble(),
      completedAt: data['completedAt'] as DateTime?,
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

/**
   * Convert UserProgress to Firestore document data
   * 
   * @return Map of progress properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseId': courseId,
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'completionPercentage': completionPercentage,
      'completedAt': completedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}