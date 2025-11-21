/**
 * App Constants
 * 
 * Centralized constants for the application
 */

class AppConstants {
  // Course Ratings
  static const double minPopularRating = 4.5;
  static const int popularCoursesLimit = 10;
  static const int maxSearchResults = 50;
  
  // Video Player
  static const Duration videoLoadTimeout = Duration(seconds: 30);
  static const Duration controlsHideDelay = Duration(seconds: 3);
  
  // Image Gallery
  static const int defaultGalleryColumns = 2;
  static const double defaultGallerySpacing = 8.0;
  static const double defaultGalleryAspectRatio = 1.0;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const double minPrice = 0.0;
  static const double maxPrice = 10000.0;
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Categories
  static const List<String> courseCategories = [
    'All',
    'Make Up',
    'Hair Styling',
    'Hair Making',
    'Nail Care',
    'Arts',
  ];
  
  // Difficulties
  static const List<String> courseDifficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  
  // Error Messages
  static const String networkError = 'Unable to connect. Please check your internet connection.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String notFoundError = 'The requested item was not found.';
  
  // Success Messages
  static const String enrollmentSuccess = 'Successfully enrolled in course!';
  static const String updateSuccess = 'Successfully updated!';
  static const String deleteSuccess = 'Successfully deleted!';
}

