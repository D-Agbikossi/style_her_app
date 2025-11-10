/**
 * User Profile Model
 * 
 * Represents a user's profile information in the StyleHer app.
 * Contains basic user data like UID, email, display name, and photo URL.
 * Used for storing and retrieving user profile information from Firestore.
 */
class UserProfile {
/**
   * User unique identifier from Firebase Auth
   */
  final String uid;

  /**
   * User email address
   */
  final String email;

  /**
   * User display name (optional)
   */
  final String? displayName;

  /**
   * User profile photo URL (optional)
   */
  final String? photoUrl;

  UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

/**
   * Create UserProfile from Firestore document data
   * 
   * @param uid Document ID (user UID)
   * @param data Document data map
   * @return UserProfile instance
   */
  factory UserProfile.fromMap(String uid, Map<String, dynamic>? data) {
    final map = data ?? {};
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }

/**
   * Convert UserProfile to Firestore document data
   * 
   * @return Map of user profile properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
