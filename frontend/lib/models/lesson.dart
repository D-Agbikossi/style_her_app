/**
 * Lesson Model
 * 
 * Represents a lesson within a course in the StyleHer app.
 * Contains lesson information including title, description, video URL, and ordering.
 * Used for storing and retrieving lesson data from Firestore.
 */
class Lesson {
/**
   * Lesson unique identifier
   */
  final String id;

  /**
   * Course ID this lesson belongs to
   */
  final String courseId;

  /**
   * Lesson title
   */
  final String title;

  /**
   * Lesson description
   */
  final String description;

  /**
   * Video URL for the lesson content
   */
  final String videoUrl;

  /**
   * Lesson duration in minutes
   */
  final int duration;

  /**
   * Order/position of the lesson within the course
   */
  final int order;

  /**
   * Whether this lesson is free to access
   */
  final bool isFree;

  /**
   * Lesson creation timestamp
   */
  final DateTime createdAt;

  /**
   * Lesson last update timestamp
   */
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.order,
    required this.isFree,
    required this.createdAt,
    required this.updatedAt,
  });

/**
   * Create Lesson from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return Lesson instance
   */
  factory Lesson.fromMap(String id, Map<String, dynamic> data) {
    return Lesson(
      id: id,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      duration: data['duration'] ?? 0,
      order: data['order'] ?? 0,
      isFree: data['isFree'] ?? false,
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

/**
   * Convert Lesson to Firestore document data
   * 
   * @return Map of lesson properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
      'isFree': isFree,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}