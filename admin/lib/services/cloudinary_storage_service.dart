/// Cloudinary Storage Service
/// 
/// Handles file uploads to Cloudinary for:
/// - Course thumbnails
/// - Course videos
/// - Course pictures
/// 
/// Cloudinary is a cloud-based media management platform that provides:
/// - Automatic image/video optimization
/// - On-the-fly transformations
/// - CDN delivery
/// - Free tier: 25GB storage, 25GB bandwidth/month

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../config/cloudinary_config.dart';

class CloudinaryStorageService {
  // Use configuration from config file
  String get _cloudName => CloudinaryConfig.cloudName;
  String get _apiKey => CloudinaryConfig.apiKey;
  String get _apiSecret => CloudinaryConfig.apiSecret;
  String get _uploadPreset => CloudinaryConfig.uploadPreset;
  bool get _useUnsignedUpload => CloudinaryConfig.useUnsignedUpload;
  
  final ImagePicker _imagePicker = ImagePicker();
  
  /// Base URL for Cloudinary uploads
  String get _uploadUrl => 'https://api.cloudinary.com/v1_1/$_cloudName';
  
  /// Upload a file to Cloudinary with progress tracking
  /// 
  /// @param file File to upload
  /// @param folder Optional folder path in Cloudinary (e.g., 'courses/thumbnails')
  /// @param resourceType 'image', 'video', or 'raw'
  /// @param onProgress Optional callback for upload progress (0.0 to 1.0)
  /// @return Secure URL of uploaded file
  Future<String> uploadFile({
    required File file,
    String? folder,
    String resourceType = 'auto', // 'image', 'video', 'auto'
    Function(double progress)? onProgress,
  }) async {
    try {
      // Generate unique file name
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      // Prepare upload request
      final uri = Uri.parse('$_uploadUrl/$resourceType/upload');
      
      // Create multipart request
      final request = http.MultipartRequest('POST', uri);
      
      // Add authentication
      request.fields['api_key'] = _apiKey;
      request.fields['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: fileName,
        ),
      );
      
      // Add folder if specified
      if (folder != null) {
        request.fields['folder'] = folder;
      }
      
      // Add upload preset if using unsigned uploads (recommended for client-side)
      if (_useUnsignedUpload && _uploadPreset.isNotEmpty && _uploadPreset != 'YOUR_UPLOAD_PRESET') {
        request.fields['upload_preset'] = _uploadPreset;
      } else {
        // For signed uploads, generate signature
        final timestamp = request.fields['timestamp']!;
        final signature = _generateSignature(
          timestamp: timestamp,
          folder: folder,
        );
        request.fields['signature'] = signature;
        request.fields['api_key'] = _apiKey;
      }
      
      // Send request with progress tracking
      final streamedResponse = await request.send();
      
      // Track progress
      int totalBytes = 0;
      int uploadedBytes = 0;
      
      if (onProgress != null) {
        streamedResponse.stream.listen(
          (chunk) {
            uploadedBytes += chunk.length;
            if (totalBytes == 0) {
              totalBytes = int.parse(streamedResponse.contentLength.toString());
            }
            if (totalBytes > 0) {
              onProgress(uploadedBytes / totalBytes);
            }
          },
        );
      }
      
      // Get response
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['secure_url'] ?? data['url'] ?? '';
      } else {
        throw Exception('Upload failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to upload file to Cloudinary: $e');
    }
  }
  
  /// Upload multiple files with progress tracking
  /// 
  /// @param files List of files to upload
  /// @param folder Optional folder path
  /// @param resourceType 'image', 'video', or 'auto'
  /// @param onProgress Optional callback for overall progress (0.0 to 1.0)
  /// @param onFileProgress Optional callback for individual file progress (fileIndex, progress)
  /// @return List of secure URLs
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    String? folder,
    String resourceType = 'auto',
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
          folder: folder,
          resourceType: resourceType,
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
      throw Exception('Failed to upload files to Cloudinary: $e');
    }
  }
  
  /// Generate signature for signed uploads
  String _generateSignature({
    required String timestamp,
    String? folder,
  }) {
    // Create string to sign
    final params = <String, String>{
      'timestamp': timestamp,
    };
    if (folder != null) {
      params['folder'] = folder;
    }
    
    // Sort parameters
    final sortedParams = params.keys.toList()..sort();
    final stringToSign = sortedParams.map((key) => '$key=${params[key]}').join('&');
    final stringToSignWithSecret = '$stringToSign$_apiSecret';
    
    // Generate SHA-1 hash
    final bytes = utf8.encode(stringToSignWithSecret);
    final hash = sha1.convert(bytes);
    return hash.toString();
  }
  
  /// Pick an image from gallery or camera
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
  
  /// Pick multiple images
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
  
  /// Pick a video file
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
  
  /// Pick a file using file picker
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
  
  /// Delete a file from Cloudinary
  /// Note: Cloudinary doesn't provide a direct delete API for client-side
  /// You'll need to use server-side API or admin API
  Future<void> deleteFile(String url) async {
    try {
      // Extract public_id from URL
      // Cloudinary URL format: https://res.cloudinary.com/{cloud_name}/{resource_type}/upload/v{version}/{public_id}.{format}
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.length < 3) {
        throw Exception('Invalid Cloudinary URL');
      }
      
      // Find the public_id (after 'upload' segment)
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex >= pathSegments.length - 1) {
        throw Exception('Invalid Cloudinary URL format');
      }
      
      // Get resource type and public_id
      final resourceType = pathSegments[uploadIndex - 1]; // 'image' or 'video'
      final publicIdWithVersion = pathSegments.sublist(uploadIndex + 2).join('/');
      final publicId = publicIdWithVersion.split('.').first; // Remove extension
      
      // Delete using admin API (requires server-side implementation)
      // For client-side, you might want to mark files for deletion in your database
      // and handle actual deletion server-side
      throw UnimplementedError(
        'File deletion requires server-side Cloudinary Admin API. '
        'Consider implementing a backend endpoint for this operation.',
      );
    } catch (e) {
      throw Exception('Failed to delete file from Cloudinary: $e');
    }
  }
  
  /// Get optimized image URL with transformations
  /// 
  /// @param originalUrl Original Cloudinary URL
  /// @param width Optional width
  /// @param height Optional height
  /// @param quality Optional quality (1-100)
  /// @return Transformed URL
  String getOptimizedImageUrl({
    required String originalUrl,
    int? width,
    int? height,
    int? quality,
  }) {
    if (!originalUrl.contains('cloudinary.com')) {
      return originalUrl; // Not a Cloudinary URL
    }
    
    final uri = Uri.parse(originalUrl);
    final pathSegments = uri.pathSegments;
    
    // Find 'upload' segment
    final uploadIndex = pathSegments.indexOf('upload');
    if (uploadIndex == -1) {
      return originalUrl;
    }
    
    // Build transformation string
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (quality != null) transformations.add('q_$quality');
    
    if (transformations.isEmpty) {
      return originalUrl;
    }
    
    // Insert transformations before 'upload'
    final newPathSegments = List<String>.from(pathSegments);
    newPathSegments.insert(uploadIndex + 1, transformations.join(','));
    
    return uri.replace(pathSegments: newPathSegments).toString();
  }
}

