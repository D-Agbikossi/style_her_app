/**
 * Storage Service
 * 
 * Handles file uploads to Firebase Storage for:
 * - Course thumbnails
 * - Course videos
 * - Course pictures
 */

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /**
   * Upload a file to Firebase Storage with progress tracking
   * 
   * @param file File to upload
   * @param path Storage path (e.g., 'courses/thumbnails/')
   * @param fileName Optional custom file name
   * @param onProgress Optional callback for upload progress (0.0 to 1.0)
   * @return Download URL of uploaded file
   */
  Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    try {
      final String name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final Reference ref = _storage.ref().child('$path$name');
      
      final UploadTask uploadTask = ref.putFile(file);
      
      // Listen to progress if callback provided
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /**
   * Upload multiple files with progress tracking
   * 
   * @param files List of files to upload
   * @param path Storage path
   * @param onProgress Optional callback for overall progress (0.0 to 1.0)
   * @param onFileProgress Optional callback for individual file progress (fileIndex, progress)
   * @return List of download URLs
   */
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String path,
    Function(double overallProgress)? onProgress,
    Function(int fileIndex, double fileProgress)? onFileProgress,
  }) async {
    try {
      final List<String> urls = [];
      final int totalFiles = files.length;
      
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final url = await uploadFile(
          file: file,
          path: path,
          onProgress: onFileProgress != null
              ? (progress) => onFileProgress(i, progress)
              : null,
        );
        urls.add(url);
        
        // Calculate overall progress
        if (onProgress != null) {
          final overallProgress = (i + 1) / totalFiles;
          onProgress(overallProgress);
        }
      }
      return urls;
    } catch (e) {
      throw Exception('Failed to upload files: $e');
    }
  }

  /**
   * Pick an image from gallery or camera
   * 
   * @param source Image source (gallery or camera)
   * @return Selected image file
   */
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /**
   * Pick multiple images
   * 
   * @return List of selected image files
   */
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      return pickedFiles.map((file) => File(file.path)).toList();
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  /**
   * Pick a video file
   * 
   * @param source Video source (gallery or camera)
   * @return Selected video file
   */
  Future<File?> pickVideo(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 30),
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick video: $e');
    }
  }

  /**
   * Pick a file using file picker (for videos or other files)
   * 
   * @param allowedExtensions Optional file extensions to allow
   * @return Selected file
   */
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );
      
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick file: $e');
    }
  }

  /**
   * Delete a file from Firebase Storage
   * 
   * @param url Download URL of the file to delete
   */
  Future<void> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /**
   * Delete multiple files
   * 
   * @param urls List of download URLs to delete
   */
  Future<void> deleteMultipleFiles(List<String> urls) async {
    try {
      for (var url in urls) {
        await deleteFile(url);
      }
    } catch (e) {
      throw Exception('Failed to delete files: $e');
    }
  }
}

