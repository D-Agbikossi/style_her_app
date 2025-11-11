/**
 * Certificate Model
 * 
 * Represents a course completion certificate in the StyleHer app.
 * Contains certificate information including user, course details, and issuance data.
 * Used for storing and retrieving completion certificates from Firestore.
 */
class Certificate {
/**
   * Certificate unique identifier
   */
  final String id;

  /**
   * User ID this certificate belongs to
   */
  final String userId;

  /**
   * Course ID this certificate is for
   */
  final String courseId;

  /**
   * Title of the completed course
   */
  final String courseTitle;

  /**
   * Certificate issuance timestamp
   */
  final DateTime issuedAt;

  /**
   * URL to the certificate image/document
   */
  final String certificateUrl;

  /**
   * Certificate creation timestamp
   */
  final DateTime createdAt;

  Certificate({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.issuedAt,
    required this.certificateUrl,
    required this.createdAt,
  });

/**
   * Create Certificate from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return Certificate instance
   */
  factory Certificate.fromMap(String id, Map<String, dynamic> data) {
    return Certificate(
      id: id,
      userId: data['userId'] ?? '',
      courseId: data['courseId'] ?? '',
      courseTitle: data['courseTitle'] ?? '',
      issuedAt: (data['issuedAt'] as DateTime?) ?? DateTime.now(),
      certificateUrl: data['certificateUrl'] ?? '',
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
    );
  }

/**
   * Convert Certificate to Firestore document data
   * 
   * @return Map of certificate properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'issuedAt': issuedAt,
      'certificateUrl': certificateUrl,
      'createdAt': createdAt,
    };
  }
}