class UserProfile {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic>? data) {
    final map = data ?? {};
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }
}
