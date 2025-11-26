/// Example: How to use UnifiedStorageService in your screens
/// 
/// This shows how to integrate Cloudinary storage into your course creation screen

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/unified_storage_service.dart';

class CourseUploadExample extends StatefulWidget {
  const CourseUploadExample({super.key});

  @override
  State<CourseUploadExample> createState() => _CourseUploadExampleState();
}

class _CourseUploadExampleState extends State<CourseUploadExample> {
  // Create storage service - switch between providers easily
  final UnifiedStorageService _storage = UnifiedStorageService(
    provider: StorageProvider.cloudinary, // Use Cloudinary
    // provider: StorageProvider.firebase, // Or use Firebase
  );

  File? _thumbnailFile;
  List<File> _videoFiles = [];
  List<File> _pictureFiles = [];
  
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  /// Pick and upload thumbnail
  Future<void> _uploadThumbnail() async {
    try {
      // Pick image
      final file = await _storage.pickImage(ImageSource.gallery);
      if (file == null) return;

      setState(() {
        _thumbnailFile = file;
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Upload to Cloudinary
      final url = await _storage.uploadFile(
        file: file,
        path: 'courses/thumbnails',
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      // Use the URL (save to Firestore, etc.)
      print('Thumbnail uploaded: $url');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thumbnail uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// Upload multiple videos
  Future<void> _uploadVideos() async {
    try {
      // Pick videos
      final files = <File>[];
      for (int i = 0; i < 3; i++) {
        final file = await _storage.pickVideo(ImageSource.gallery);
        if (file != null) files.add(file);
      }

      if (files.isEmpty) return;

      setState(() {
        _videoFiles = files;
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Upload all videos
      final urls = await _storage.uploadMultipleFiles(
        files: files,
        path: 'courses/videos',
        onProgress: (overallProgress) {
          setState(() {
            _uploadProgress = overallProgress;
          });
        },
        onFileProgress: (fileIndex, fileProgress) {
          print('File $fileIndex: ${(fileProgress * 100).toStringAsFixed(1)}%');
        },
      );

      print('Videos uploaded: $urls');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${urls.length} videos uploaded!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// Upload pictures
  Future<void> _uploadPictures() async {
    try {
      // Pick multiple images
      final files = await _storage.pickMultipleImages();
      if (files.isEmpty) return;

      setState(() {
        _pictureFiles = files;
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Upload all pictures
      final urls = await _storage.uploadMultipleFiles(
        files: files,
        path: 'courses/pictures',
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      print('Pictures uploaded: $urls');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${urls.length} pictures uploaded!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// Get optimized thumbnail URL (Cloudinary only)
  String _getOptimizedThumbnail(String originalUrl) {
    if (_storage is UnifiedStorageService) {
      return _storage.getOptimizedImageUrl(
        originalUrl: originalUrl,
        width: 400,
        height: 300,
        quality: 80,
      );
    }
    return originalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail Upload
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadThumbnail,
              child: const Text('Upload Thumbnail'),
            ),
            if (_isUploading && _thumbnailFile != null)
              LinearProgressIndicator(value: _uploadProgress),
            
            const SizedBox(height: 16),
            
            // Video Upload
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadVideos,
              child: const Text('Upload Videos'),
            ),
            if (_isUploading && _videoFiles.isNotEmpty)
              LinearProgressIndicator(value: _uploadProgress),
            
            const SizedBox(height: 16),
            
            // Picture Upload
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadPictures,
              child: const Text('Upload Pictures'),
            ),
            if (_isUploading && _pictureFiles.isNotEmpty)
              LinearProgressIndicator(value: _uploadProgress),
          ],
        ),
      ),
    );
  }
}

