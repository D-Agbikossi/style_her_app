/**
 * Validation Utilities
 * 
 * Common validation functions for forms
 */

class Validators {
  /**
   * Validate email address
   */
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /**
   * Validate URL
   * Supports standard URLs and common video hosting platforms (YouTube, Vimeo, etc.)
   */
  static String? url(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }
    
    // Trim whitespace
    final trimmedValue = value.trim();
    
    // Check if it starts with http:// or https://
    if (!trimmedValue.startsWith('http://') && !trimmedValue.startsWith('https://')) {
      return 'URL must start with http:// or https://';
    }
    
    // Try to parse as URI to validate format
    try {
      final uri = Uri.parse(trimmedValue);
      
      // Check if URI has a valid scheme
      if (uri.scheme.isEmpty || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return 'URL must use http:// or https:// protocol';
      }
      
      // Check if URI has a host
      if (uri.host.isEmpty) {
        return 'Please enter a valid URL with a domain name (e.g., youtube.com)';
      }
      
      // Remove 'www.' prefix for validation
      final hostWithoutWww = uri.host.startsWith('www.') 
          ? uri.host.substring(4) 
          : uri.host;
      
      // Check for valid domain structure
      // Must have at least one dot (for TLD) OR be a known short domain
      final validShortDomains = ['youtu.be', 'bit.ly', 'tinyurl.com', 't.co'];
      final hasValidDomain = hostWithoutWww.contains('.') || validShortDomains.contains(hostWithoutWww);
      
      if (!hasValidDomain) {
        return 'Please enter a valid URL with a proper domain name (e.g., youtube.com, vimeo.com)';
      }
      
      // Additional validation: check for common video hosting domains
      // Note: We allow any valid URL structure, including custom hosting
      // Known video domains are accepted but not required
      
      return null; // URL is valid
    } catch (e) {
      // If parsing fails, provide helpful error message
      return 'Please enter a valid URL format (e.g., https://www.youtube.com/watch?v=VIDEO_ID)';
    }
  }

  /**
   * Validate required field
   */
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /**
   * Validate minimum length
   */
  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'This field'} must be at least $min characters';
    }
    return null;
  }

  /**
   * Validate maximum length
   */
  static String? maxLength(String? value, int max, [String? fieldName]) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'This field'} must be at most $max characters';
    }
    return null;
  }

  /**
   * Validate number
   */
  static String? number(String? value, {bool required = false, double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return required ? 'Number is required' : null;
    }
    final num = double.tryParse(value);
    if (num == null) {
      return 'Please enter a valid number';
    }
    if (min != null && num < min) {
      return 'Value must be at least $min';
    }
    if (max != null && num > max) {
      return 'Value must be at most $max';
    }
    return null;
  }

  /**
   * Validate integer
   */
  static String? integer(String? value, {bool required = false, int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return required ? 'Number is required' : null;
    }
    final num = int.tryParse(value);
    if (num == null) {
      return 'Please enter a valid whole number';
    }
    if (min != null && num < min) {
      return 'Value must be at least $min';
    }
    if (max != null && num > max) {
      return 'Value must be at most $max';
    }
    return null;
  }

  /**
   * Validate price
   */
  static String? price(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'Price is required' : null;
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    if (price > 10000) {
      return 'Price cannot exceed \$10,000';
    }
    return null;
  }
}

