/**
 * Error Handler Utility
 * 
 * Provides user-friendly error messages by converting technical exceptions
 * into clear, actionable messages for administrators.
 */

class ErrorHandler {
  /// Convert technical error messages to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'Something went wrong. Please try again.';
    }

    final errorString = error.toString().toLowerCase();
    final errorMessage = error.toString();

    // Network/Connection Errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('socket') ||
        errorString.contains('timeout') ||
        errorString.contains('failed host lookup')) {
      return 'Unable to connect. Please check your internet connection and try again.';
    }

    // Authentication Errors
    if (errorString.contains('user-not-found') ||
        errorString.contains('wrong-password') ||
        errorString.contains('invalid-credential')) {
      return 'Incorrect email or password. Please try again.';
    }

    if (errorString.contains('email-already-in-use') ||
        errorString.contains('email already exists')) {
      return 'This email is already registered. Please use a different email.';
    }

    if (errorString.contains('weak-password')) {
      return 'Password is too weak. Please use at least 6 characters.';
    }

    if (errorString.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }

    if (errorString.contains('user-disabled')) {
      return 'This account has been disabled.';
    }

    if (errorString.contains('too-many-requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    // Permission Errors
    if (errorString.contains('permission-denied') ||
        errorString.contains('access denied')) {
      return 'You don\'t have permission to perform this action.';
    }

    // Not Found Errors
    if (errorString.contains('not-found') ||
        errorString.contains('does not exist')) {
      return 'The requested item was not found.';
    }

    // Validation Errors
    if (errorString.contains('invalid') && errorString.contains('url')) {
      return 'Please enter a valid URL (e.g., https://example.com).';
    }

    if (errorString.contains('required') || errorString.contains('cannot be empty')) {
      return 'Please fill in all required fields.';
    }

    // Firebase/Firestore Errors
    if (errorString.contains('firestore') || errorString.contains('firebase')) {
      if (errorString.contains('unavailable')) {
        return 'Service is temporarily unavailable. Please try again later.';
      }
      return 'Unable to save data. Please check your connection and try again.';
    }

    // File/Upload Errors
    if (errorString.contains('upload') || errorString.contains('file')) {
      if (errorString.contains('size') || errorString.contains('too large')) {
        return 'File is too large. Please choose a smaller file.';
      }
      return 'Unable to upload file. Please try again.';
    }

    // Generic Exception Handling
    if (errorMessage.startsWith('Exception: ')) {
      final cleanMessage = errorMessage.replaceFirst('Exception: ', '');
      // If it's already user-friendly, return it
      if (!cleanMessage.contains('failed') && 
          !cleanMessage.contains('error') &&
          cleanMessage.length < 100) {
        return cleanMessage;
      }
    }

    // Default user-friendly message
    return 'Something went wrong. Please try again.';
  }

  /// Get a user-friendly title for error dialogs
  static String getErrorTitle(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Connection Error';
    }

    if (errorString.contains('auth') || errorString.contains('login') || errorString.contains('password')) {
      return 'Authentication Error';
    }

    if (errorString.contains('permission') || errorString.contains('access')) {
      return 'Access Denied';
    }

    if (errorString.contains('not-found')) {
      return 'Not Found';
    }

    return 'Error';
  }
}


