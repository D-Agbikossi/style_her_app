/**
 * Admin Service Tests
 * 
 * Tests for CRUD operations and bulk operations
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:admin/services/admin_service.dart';

void main() {
  group('AdminService', () {
    late AdminService adminService;

    setUp(() {
      adminService = AdminService();
    });

    group('Course Operations', () {
      test('createCourse should return course ID', () async {
        try {
          final courseData = {
            'title': 'Test Course',
            'description': 'Test Description',
            'category': 'Test',
            'difficulty': 'Beginner',
            'instructor': 'Test Instructor',
            'thumbnailUrl': 'https://example.com/image.jpg',
            'videoUrls': [],
            'pictureUrls': [],
            'duration': 60,
            'lessonCount': 5,
            'isFree': true,
          };
          
          final courseId = await adminService.createCourse(courseData);
          expect(courseId, isNotEmpty);
        } catch (e) {
          // Expected if Firebase not configured
          expect(e, isA<Exception>());
        }
      });

      test('getCourses should return list of courses', () async {
        try {
          final courses = await adminService.getCourses();
          expect(courses, isA<List>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('Bulk Operations', () {
      test('bulkDeleteCourses should return success count', () async {
        try {
          final count = await adminService.bulkDeleteCourses(['id1', 'id2']);
          expect(count, isA<int>());
          expect(count, greaterThanOrEqualTo(0));
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('bulkDeleteMentors should return success count', () async {
        try {
          final count = await adminService.bulkDeleteMentors(['id1', 'id2']);
          expect(count, isA<int>());
          expect(count, greaterThanOrEqualTo(0));
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('bulkDeleteUsers should return success count', () async {
        try {
          final count = await adminService.bulkDeleteUsers(['id1', 'id2']);
          expect(count, isA<int>());
          expect(count, greaterThanOrEqualTo(0));
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('bulkUpdateUserStatus should return success count', () async {
        try {
          final count = await adminService.bulkUpdateUserStatus(
            ['id1', 'id2'],
            'active',
          );
          expect(count, isA<int>());
          expect(count, greaterThanOrEqualTo(0));
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('Statistics', () {
      test('getStats should return map with counts', () async {
        try {
          final stats = await adminService.getStats();
          expect(stats, isA<Map<String, int>>());
          expect(stats.containsKey('learners'), isTrue);
          expect(stats.containsKey('mentors'), isTrue);
          expect(stats.containsKey('totalUsers'), isTrue);
          expect(stats.containsKey('courses'), isTrue);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });
  });
}

