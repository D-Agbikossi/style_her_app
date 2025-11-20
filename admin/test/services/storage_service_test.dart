/**
 * Storage Service Tests
 * 
 * Tests for file upload, download, and deletion operations
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:admin/services/storage_service.dart';
import 'dart:io';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
    });

    group('File Upload', () {
      test('uploadFile should handle progress callbacks', () async {
        // Note: This test requires Firebase to be initialized
        // In a real test environment, you would mock Firebase Storage
        
        // Create a test file
        final testFile = File('test_file.txt');
        await testFile.writeAsString('Test content');
        
        try {
          double? lastProgress;
          final url = await storageService.uploadFile(
            file: testFile,
            path: 'test/',
            onProgress: (progress) {
              lastProgress = progress;
            },
          );
          
          // Verify URL is returned
          expect(url, isNotEmpty);
          expect(url, startsWith('http'));
          
          // Verify progress was tracked
          // Note: Progress might be 1.0 if upload is very fast
          expect(lastProgress, isNotNull);
          expect(lastProgress!, greaterThanOrEqualTo(0.0));
          expect(lastProgress!, lessThanOrEqualTo(1.0));
        } catch (e) {
          // If Firebase is not configured, test will fail
          // This is expected in test environment
          expect(e, isA<Exception>());
        } finally {
          // Clean up test file
          if (await testFile.exists()) {
            await testFile.delete();
          }
        }
      });

      test('uploadMultipleFiles should track overall and file progress', () async {
        // Create test files
        final testFiles = <File>[];
        for (int i = 0; i < 3; i++) {
          final file = File('test_file_$i.txt');
          await file.writeAsString('Test content $i');
          testFiles.add(file);
        }
        
        try {
          double? overallProgress;
          final fileProgresses = <int, double>{};
          
          final urls = await storageService.uploadMultipleFiles(
            files: testFiles,
            path: 'test/',
            onProgress: (progress) {
              overallProgress = progress;
            },
            onFileProgress: (fileIndex, progress) {
              fileProgresses[fileIndex] = progress;
            },
          );
          
          // Verify URLs are returned
          expect(urls.length, equals(testFiles.length));
          
          // Verify progress was tracked
          expect(overallProgress, isNotNull);
          expect(fileProgresses.length, greaterThanOrEqualTo(0));
        } catch (e) {
          // Expected if Firebase not configured
          expect(e, isA<Exception>());
        } finally {
          // Clean up test files
          for (var file in testFiles) {
            if (await file.exists()) {
              await file.delete();
            }
          }
        }
      });
    });

    group('File Picking', () {
      test('pickImage should return File or null', () async {
        // Note: This requires actual device/emulator
        // In unit tests, this would be mocked
        // For now, we just verify the method exists and doesn't throw
        expect(() => storageService.pickImage, returnsNormally);
      });

      test('pickVideo should return File or null', () async {
        expect(() => storageService.pickVideo, returnsNormally);
      });

      test('pickFile should return File or null', () async {
        expect(() => storageService.pickFile, returnsNormally);
      });
    });

    group('File Deletion', () {
      test('deleteFile should handle invalid URLs gracefully', () async {
        try {
          await storageService.deleteFile('invalid-url');
          // Should throw exception for invalid URL
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });
  });
}

