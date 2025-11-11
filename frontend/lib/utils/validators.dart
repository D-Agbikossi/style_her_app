/**
 * Input Validators
 * 
 * This file contains all form validation logic for the StyleHer app.
 * Provides reusable validation functions for different input types.
 * 
 * Validators included:
 * - Email validation (format and required field)
 * - Password validation (length and required field)
 * - Name validation (required field)
 * - Country validation (required field)
 */

/**
 * Email validator function
 * 
 * Validates email format and checks for required field
 * 
 * @param value The email input value to validate
 * @return Error message if validation fails, null if valid
 */
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

/**
 * Password validator function
 * 
 * Validates password length and checks for required field
 * 
 * @param value The password input value to validate
 * @return Error message if validation fails, null if valid
 */
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

/**
 * Name validator function
 * 
 * Validates that the name field is not empty
 * 
 * @param value The name input value to validate
 * @return Error message if validation fails, null if valid
 */
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your full name';
  }
  return null;
}

/**
 * Country validator function
 * 
 * Validates that the country field is not empty
 * 
 * @param value The country input value to validate
 * @return Error message if validation fails, null if valid
 */
String? validateCountry(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your country';
  }
  return null;
}

/**
 * Generic required field validator
 * 
 * Validates that a field is not empty
 * 
 * @param value The input value to validate
 * @param fieldName The name of the field for error message
 * @return Error message if validation fails, null if valid
 */
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $fieldName';
  }
  return null;
}