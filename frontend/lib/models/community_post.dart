/**
 * Community Post Model
 * 
 * Represents a community post in the StyleHer app.
 * Contains post information including user details, content, likes, and comments.
 * Used for storing and retrieving community posts from Firestore.
 */
class CommunityPost {
/**
   * Post unique identifier
   */
  final String id;

  /**
   * User ID of the post creator
   */
  final String userId;

  /**
   * Display name of the post creator
   */
  final String userName;

  /**
   * Profile photo URL of the post creator (optional)
   */
  final String? userPhotoUrl;

  /**
   * Post content text
   */
  final String content;

  /**
   * Post image URL (optional)
   */
  final String? imageUrl;

  /**
   * List of user IDs who liked the post
   */
  final List<String> likes;

  /**
   * Number of comments on the post
   */
  final int commentsCount;

  /**
   * Post creation timestamp
   */
  final DateTime createdAt;

  /**
   * Post last update timestamp
   */
  final DateTime updatedAt;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

/**
   * Create CommunityPost from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return CommunityPost instance
   */
  factory CommunityPost.fromMap(String id, Map<String, dynamic> data) {
    return CommunityPost(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhotoUrl: data['userPhotoUrl'],
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      likes: List<String>.from(data['likes'] ?? []),
      commentsCount: data['commentsCount'] ?? 0,
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

/**
   * Convert CommunityPost to Firestore document data
   * 
   * @return Map of post properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'commentsCount': commentsCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

/**
   * Check if a user has liked this post
   * 
   * @param userId User ID to check
   * @return true if user has liked the post, false otherwise
   */
  bool isLikedBy(String userId) => likes.contains(userId);
}