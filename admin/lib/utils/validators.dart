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
   */
  static String? url(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'URL is required' : null;
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL (must start with http:// or https://)';
    }
    return null;
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

