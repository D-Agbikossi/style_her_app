/// Unified Storage Service
/// 
/// Provides a unified interface for file storage that can switch between
/// Firebase Storage and Cloudinary based on configuration.
/// 
/// Usage:
/// ```dart
/// final storage = UnifiedStorageService(useCloudinary: true);
/// final url = await storage.uploadFile(file: file, path: 'courses/thumbnails');
/// ```

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'storage_service.dart';
import 'cloudinary_storage_service.dart';

enum StorageProvider {
  firebase,
  cloudinary,
}

class UnifiedStorageService {
  final StorageProvider _provider;
  final StorageService? _firebaseStorage;
  final CloudinaryStorageService? _cloudinaryStorage;

  /// Create a unified storage service
  /// 
  /// @param provider Storage provider to use (default: cloudinary)
  UnifiedStorageService({
    StorageProvider provider = StorageProvider.cloudinary,
  })  : _provider = provider,
        _firebaseStorage = provider == StorageProvider.firebase
            ? StorageService()
            : null,
        _cloudinaryStorage = provider == StorageProvider.cloudinary
            ? CloudinaryStorageService()
            : null;

  /// Upload a file with progress tracking
  Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
    String? resourceType, // For Cloudinary: 'image', 'video', or 'auto'
    Function(double progress)? onProgress,
  }) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.uploadFile(
          file: file,
          path: path,
          fileName: fileName,
          onProgress: onProgress,
        );
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.uploadFile(
          file: file,
          folder: path,
          resourceType: resourceType ?? 'auto',
          onProgress: onProgress,
        );
    }
  }

  /// Upload multiple files with progress tracking
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String path,
    Function(double overallProgress)? onProgress,
    Function(int fileIndex, double fileProgress)? onFileProgress,
  }) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.uploadMultipleFiles(
          files: files,
          path: path,
          onProgress: onProgress,
          onFileProgress: onFileProgress,
        );
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.uploadMultipleFiles(
          files: files,
          folder: path,
          onProgress: onProgress,
          onFileProgress: onFileProgress,
        );
    }
  }

  /// Pick an image from gallery or camera
  Future<File?> pickImage(ImageSource source) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.pickImage(source);
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.pickImage(source);
    }
  }

  /// Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.pickMultipleImages();
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.pickMultipleImages();
    }
  }

  /// Pick a video file
  Future<File?> pickVideo(ImageSource source) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.pickVideo(source);
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.pickVideo(source);
    }
  }

  /// Pick a file using file picker
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.pickFile(
          allowedExtensions: allowedExtensions,
        );
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.pickFile(
          allowedExtensions: allowedExtensions,
        );
    }
  }

  /// Delete a file
  Future<void> deleteFile(String url) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.deleteFile(url);
      case StorageProvider.cloudinary:
        return await _cloudinaryStorage!.deleteFile(url);
    }
  }

  /// Delete multiple files
  Future<void> deleteMultipleFiles(List<String> urls) async {
    switch (_provider) {
      case StorageProvider.firebase:
        return await _firebaseStorage!.deleteMultipleFiles(urls);
      case StorageProvider.cloudinary:
        for (var url in urls) {
          await _cloudinaryStorage!.deleteFile(url);
        }
        break;
    }
  }

  /// Get optimized image URL (Cloudinary only)
  /// For Firebase, returns original URL
  String getOptimizedImageUrl({
    required String originalUrl,
    int? width,
    int? height,
    int? quality,
  }) {
    if (_provider == StorageProvider.cloudinary) {
      return _cloudinaryStorage!.getOptimizedImageUrl(
        originalUrl: originalUrl,
        width: width,
        height: height,
        quality: quality,
      );
    }
    return originalUrl;
  }
}

