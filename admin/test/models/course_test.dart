/**
 * Course Model Tests
 * 
 * Tests for Course model serialization and deserialization
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:admin/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Course Model', () {
    test('fromMap should create Course from Firestore data', () {
      final data = {
        'title': 'Test Course',
        'description': 'Test Description',
        'category': 'Make Up',
        'difficulty': 'Beginner',
        'instructor': 'Test Instructor',
        'thumbnailUrl': 'https://example.com/image.jpg',
        'videoUrls': ['https://example.com/video1.mp4'],
        'pictureUrls': ['https://example.com/pic1.jpg'],
        'duration': 60,
        'lessonCount': 5,
        'rating': 4.5,
        'enrolledCount': 100,
        'isFree': false,
        'price': 29.99,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final course = Course.fromMap('test-id', data);

      expect(course.id, equals('test-id'));
      expect(course.title, equals('Test Course'));
      expect(course.description, equals('Test Description'));
      expect(course.category, equals('Make Up'));
      expect(course.difficulty, equals('Beginner'));
      expect(course.instructor, equals('Test Instructor'));
      expect(course.thumbnailUrl, equals('https://example.com/image.jpg'));
      expect(course.videoUrls.length, equals(1));
      expect(course.pictureUrls.length, equals(1));
      expect(course.duration, equals(60));
      expect(course.lessonCount, equals(5));
      expect(course.rating, equals(4.5));
      expect(course.enrolledCount, equals(100));
      expect(course.isFree, isFalse);
      expect(course.price, equals(29.99));
    });

    test('fromMap should handle missing optional fields', () {
      final data = {
        'title': 'Test Course',
        'description': 'Test Description',
        'category': 'Make Up',
        'difficulty': 'Beginner',
        'instructor': 'Test Instructor',
        'thumbnailUrl': '',
        'videoUrls': [],
        'pictureUrls': [],
        'duration': 0,
        'lessonCount': 0,
        'rating': 0.0,
        'enrolledCount': 0,
        'isFree': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final course = Course.fromMap('test-id', data);

      expect(course.price, isNull);
      expect(course.isFree, isTrue);
      expect(course.videoUrls, isEmpty);
      expect(course.pictureUrls, isEmpty);
    });

    test('toMap should convert Course to Firestore data', () {
      final course = Course(
        id: 'test-id',
        title: 'Test Course',
        description: 'Test Description',
        category: 'Make Up',
        difficulty: 'Beginner',
        instructor: 'Test Instructor',
        thumbnailUrl: 'https://example.com/image.jpg',
        videoUrls: ['https://example.com/video1.mp4'],
        pictureUrls: ['https://example.com/pic1.jpg'],
        duration: 60,
        lessonCount: 5,
        rating: 4.5,
        enrolledCount: 100,
        isFree: false,
        price: 29.99,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final data = course.toMap();

      expect(data['title'], equals('Test Course'));
      expect(data['description'], equals('Test Description'));
      expect(data['category'], equals('Make Up'));
      expect(data['difficulty'], equals('Beginner'));
      expect(data['instructor'], equals('Test Instructor'));
      expect(data['thumbnailUrl'], equals('https://example.com/image.jpg'));
      expect(data['videoUrls'], isA<List>());
      expect(data['pictureUrls'], isA<List>());
      expect(data['duration'], equals(60));
      expect(data['lessonCount'], equals(5));
      expect(data['rating'], equals(4.5));
      expect(data['enrolledCount'], equals(100));
      expect(data['isFree'], isFalse);
      expect(data['price'], equals(29.99));
    });

    test('toMap should handle null price for free courses', () {
      final course = Course(
        id: 'test-id',
        title: 'Free Course',
        description: 'Description',
        category: 'Make Up',
        difficulty: 'Beginner',
        instructor: 'Instructor',
        thumbnailUrl: '',
        duration: 30,
        lessonCount: 3,
        rating: 0.0,
        enrolledCount: 0,
        isFree: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final data = course.toMap();

      expect(data['isFree'], isTrue);
      expect(data['price'], isNull);
    });
  });
}

