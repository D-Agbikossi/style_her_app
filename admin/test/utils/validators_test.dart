/**
 * Validators Tests
 * 
 * Tests for all validation functions
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:admin/utils/validators.dart';

void main() {
  group('Validators', () {
    group('Email Validation', () {
      test('should validate correct email addresses', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name@domain.co.uk'), isNull);
        expect(Validators.email('admin@test.io'), isNull);
      });

      test('should reject invalid email addresses', () {
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('test@'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
        expect(Validators.email('test.example.com'), isNotNull);
      });

      test('should require email field', () {
        expect(Validators.email(null), isNotNull);
        expect(Validators.email(''), isNotNull);
      });
    });

    group('URL Validation', () {
      test('should validate correct URLs', () {
        expect(Validators.url('https://example.com'), isNull);
        expect(Validators.url('http://test.com/path'), isNull);
        expect(Validators.url('https://www.example.com/image.jpg'), isNull);
      });

      test('should reject invalid URLs', () {
        expect(Validators.url('not-a-url'), isNotNull);
        expect(Validators.url('example.com'), isNotNull);
        expect(Validators.url('ftp://example.com'), isNotNull);
      });

      test('should allow empty URL when not required', () {
        expect(Validators.url(null, required: false), isNull);
        expect(Validators.url('', required: false), isNull);
      });

      test('should require URL when required is true', () {
        expect(Validators.url(null, required: true), isNotNull);
        expect(Validators.url('', required: true), isNotNull);
      });
    });

    group('Required Field Validation', () {
      test('should validate non-empty values', () {
        expect(Validators.required('value'), isNull);
        expect(Validators.required('test'), isNull);
      });

      test('should reject empty values', () {
        expect(Validators.required(null), isNotNull);
        expect(Validators.required(''), isNotNull);
        expect(Validators.required('   '), isNotNull);
      });

      test('should use custom field name in error', () {
        final error = Validators.required('', 'Custom Field');
        expect(error, contains('Custom Field'));
      });
    });

    group('Length Validation', () {
      test('minLength should validate minimum length', () {
        expect(Validators.minLength('test', 3), isNull);
        expect(Validators.minLength('test', 4), isNull);
        expect(Validators.minLength('test', 5), isNotNull);
      });

      test('maxLength should validate maximum length', () {
        expect(Validators.maxLength('test', 5), isNull);
        expect(Validators.maxLength('test', 4), isNull);
        expect(Validators.maxLength('test', 3), isNotNull);
      });
    });

    group('Number Validation', () {
      test('should validate valid numbers', () {
        expect(Validators.number('123'), isNull);
        expect(Validators.number('45.67'), isNull);
        expect(Validators.number('0'), isNull);
      });

      test('should reject invalid numbers', () {
        expect(Validators.number('abc'), isNotNull);
        expect(Validators.number('12.34.56'), isNotNull);
      });

      test('should validate min/max constraints', () {
        expect(Validators.number('50', min: 0, max: 100), isNull);
        expect(Validators.number('150', min: 0, max: 100), isNotNull);
        expect(Validators.number('-10', min: 0, max: 100), isNotNull);
      });

      test('should allow empty when not required', () {
        expect(Validators.number(null, required: false), isNull);
        expect(Validators.number('', required: false), isNull);
      });
    });

    group('Integer Validation', () {
      test('should validate valid integers', () {
        expect(Validators.integer('123'), isNull);
        expect(Validators.integer('0'), isNull);
        expect(Validators.integer('999'), isNull);
      });

      test('should reject decimals', () {
        expect(Validators.integer('12.5'), isNotNull);
        expect(Validators.integer('45.67'), isNotNull);
      });

      test('should validate min/max constraints', () {
        expect(Validators.integer('50', min: 1, max: 100), isNull);
        expect(Validators.integer('0', min: 1, max: 100), isNotNull);
        expect(Validators.integer('150', min: 1, max: 100), isNotNull);
      });
    });

    group('Price Validation', () {
      test('should validate valid prices', () {
        expect(Validators.price('0'), isNull);
        expect(Validators.price('9.99'), isNull);
        expect(Validators.price('100'), isNull);
        expect(Validators.price('9999.99'), isNull);
      });

      test('should reject negative prices', () {
        expect(Validators.price('-10'), isNotNull);
      });

      test('should reject prices over 10000', () {
        expect(Validators.price('10001'), isNotNull);
        expect(Validators.price('20000'), isNotNull);
      });

      test('should reject invalid price format', () {
        expect(Validators.price('abc'), isNotNull);
        expect(Validators.price('12.34.56'), isNotNull);
      });

      test('should allow empty when not required', () {
        expect(Validators.price(null, required: false), isNull);
        expect(Validators.price('', required: false), isNull);
      });
    });
  });
}

