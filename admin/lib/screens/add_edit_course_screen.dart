/**
 * Add/Edit Course Screen - Course Creation and Editing
 * 
 * This screen handles course creation and editing functionality including:
 * - Form validation for all course fields
 * - Category and difficulty selection
 * - Free/paid course configuration
 * - Thumbnail URL input
 * - Duration and lesson count specification
 * - Real-time category loading from Firestore
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

// Model imports
import '../models/course.dart';

// Service imports
import '../services/admin_service.dart';
import '../services/storage_service.dart';

// Utils imports
import '../utils/validators.dart';

// Route imports
import '../routes.dart';

// Theme imports
import '../main.dart';

/**
 * AddEditCourseScreen - Stateful widget for course creation/editing
 * Handles both creating new courses and editing existing ones
 */
class AddEditCourseScreen extends StatefulWidget {
  final Course? course; // Course to edit (null for new course)

  const AddEditCourseScreen({super.key, this.course});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

/**
 * Add/edit course screen state management
 * Handles form state, validation, category loading, and course saving
 */
class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  // Form state
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService();
  final _storageService = StorageService();
  
  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _durationController = TextEditingController();
  final _lessonCountController = TextEditingController();
  final _priceController = TextEditingController();
  
  // Video and picture URLs
  final List<TextEditingController> _videoUrlControllers = [];
  final List<TextEditingController> _pictureUrlControllers = [];
  
  // File uploads
  File? _thumbnailFile;
  final List<File> _videoFiles = [];
  final List<File> _pictureFiles = [];
  final List<String> _uploadedVideoUrls = [];
  final List<String> _uploadedPictureUrls = [];

  // Selection state
  String _selectedCategory = 'Make Up';
  String _selectedDifficulty = 'Beginner';
  bool _isFree = false;
  bool _isLoading = false;
  bool _isUploading = false;
  List<String> _categories = ['Make Up', 'Hair Styling', 'Hair Making', 'Nail Care', 'Arts'];
  
  // Upload progress tracking
  double _uploadProgress = 0.0;
  String _uploadStatus = '';
  final Map<int, double> _fileProgress = {}; // Track individual file progress


  Future<void> _loadCategories() async {
    final categories = await _adminService.getCategoryNames();
    if (categories.isNotEmpty) {
      setState(() {
        _categories = categories;
        if (widget.course != null && _categories.contains(widget.course!.category)) {
          _selectedCategory = widget.course!.category;
        }
      });
    }
  }

  void _populateForm() {
    final course = widget.course!;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _instructorController.text = course.instructor;
    _thumbnailUrlController.text = course.thumbnailUrl;
    _durationController.text = course.duration.toString();
    _lessonCountController.text = course.lessonCount.toString();
    _priceController.text = course.price?.toString() ?? '';
    _selectedCategory = course.category;
    _selectedDifficulty = course.difficulty;
    _isFree = course.isFree;
    
    // Populate video URLs
    _videoUrlControllers.clear();
    if (course.videoUrls.isNotEmpty) {
      for (var url in course.videoUrls) {
        final controller = TextEditingController(text: url);
        _videoUrlControllers.add(controller);
      }
    } else {
      _videoUrlControllers.add(TextEditingController());
    }
    
    // Populate picture URLs
    _pictureUrlControllers.clear();
    if (course.pictureUrls.isNotEmpty) {
      for (var url in course.pictureUrls) {
        final controller = TextEditingController(text: url);
        _pictureUrlControllers.add(controller);
      }
    } else {
      _pictureUrlControllers.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.course != null) {
      _populateForm();
    } else {
      // Initialize with one empty field for new course
      _videoUrlControllers.add(TextEditingController());
      _pictureUrlControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _thumbnailUrlController.dispose();
    _durationController.dispose();
    _lessonCountController.dispose();
    _priceController.dispose();
    for (var controller in _videoUrlControllers) {
      controller.dispose();
    }
    for (var controller in _pictureUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate that at least thumbnail URL or file is provided
    if (_thumbnailUrlController.text.trim().isEmpty && _thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a thumbnail (upload file or enter URL)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isUploading = true;
    });

    try {
      String thumbnailUrl = _thumbnailUrlController.text.trim();
      
      // Upload thumbnail if file is selected
      if (_thumbnailFile != null) {
        setState(() {
          _uploadStatus = 'Uploading thumbnail...';
          _uploadProgress = 0.0;
        });
        thumbnailUrl = await _storageService.uploadFile(
          file: _thumbnailFile!,
          path: 'courses/thumbnails/',
          onProgress: (progress) {
            if (mounted) {
              setState(() => _uploadProgress = progress);
            }
          },
        );
      }

      // Upload video files
      if (_videoFiles.isNotEmpty) {
        setState(() {
          _uploadStatus = 'Uploading ${_videoFiles.length} video(s)...';
          _uploadProgress = 0.0;
          _fileProgress.clear();
        });
        final uploadedUrls = await _storageService.uploadMultipleFiles(
          files: _videoFiles,
          path: 'courses/videos/',
          onProgress: (overallProgress) {
            if (mounted) {
              setState(() => _uploadProgress = overallProgress);
            }
          },
          onFileProgress: (fileIndex, fileProgress) {
            if (mounted) {
              setState(() {
                _fileProgress[fileIndex] = fileProgress;
                _uploadStatus = 'Uploading video ${fileIndex + 1}/${_videoFiles.length}...';
              });
            }
          },
        );
        _uploadedVideoUrls.addAll(uploadedUrls);
      }

      // Upload picture files
      if (_pictureFiles.isNotEmpty) {
        setState(() {
          _uploadStatus = 'Uploading ${_pictureFiles.length} image(s)...';
          _uploadProgress = 0.0;
          _fileProgress.clear();
        });
        final uploadedUrls = await _storageService.uploadMultipleFiles(
          files: _pictureFiles,
          path: 'courses/pictures/',
          onProgress: (overallProgress) {
            if (mounted) {
              setState(() => _uploadProgress = overallProgress);
            }
          },
          onFileProgress: (fileIndex, fileProgress) {
            if (mounted) {
              setState(() {
                _fileProgress[fileIndex] = fileProgress;
                _uploadStatus = 'Uploading image ${fileIndex + 1}/${_pictureFiles.length}...';
              });
            }
          },
        );
        _uploadedPictureUrls.addAll(uploadedUrls);
      }
      
      setState(() {
        _uploadStatus = 'Saving course data...';
        _uploadProgress = 1.0;
      });

      // Collect video URLs (from both uploads and manual URLs)
      final videoUrls = [
        ..._uploadedVideoUrls,
        ..._videoUrlControllers
            .map((c) => c.text.trim())
            .where((url) => url.isNotEmpty && Validators.url(url) == null),
      ];
      
      // Collect picture URLs (from both uploads and manual URLs)
      final pictureUrls = [
        ..._uploadedPictureUrls,
        ..._pictureUrlControllers
            .map((c) => c.text.trim())
            .where((url) => url.isNotEmpty && Validators.url(url) == null),
      ];
      
      final courseData = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'difficulty': _selectedDifficulty,
        'instructor': _instructorController.text.trim(),
        'thumbnailUrl': thumbnailUrl,
        'videoUrls': videoUrls,
        'pictureUrls': pictureUrls,
        'duration': int.tryParse(_durationController.text) ?? 0,
        'lessonCount': int.tryParse(_lessonCountController.text) ?? 0,
        'isFree': _isFree,
        'price': _isFree ? null : (double.tryParse(_priceController.text) ?? 0.0),
      };
      
      if (widget.course == null) {
        courseData['createdAt'] = FieldValue.serverTimestamp();
      }
      courseData['updatedAt'] = FieldValue.serverTimestamp();

      setState(() => _isUploading = false);

      if (widget.course != null) {
        await _adminService.updateCourse(widget.course!.id, courseData);
      } else {
        await _adminService.createCourse(courseData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.course != null ? 'Course updated!' : 'Course created!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _pickThumbnail() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final file = await _storageService.pickImage(source);
      if (file != null && mounted) {
        setState(() {
          _thumbnailFile = file;
          _thumbnailUrlController.clear();
        });
      }
    }
  }

  Future<void> _pickVideos() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Video Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('File Picker'),
              onTap: () => Navigator.pop(context, ImageSource.gallery), // Use file picker
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      if (source == ImageSource.gallery) {
        // Use file picker for better video selection
        final file = await _storageService.pickFile(
          allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
        );
        if (file != null && mounted) {
          setState(() => _videoFiles.add(file));
        }
      } else {
        final file = await _storageService.pickVideo(source);
        if (file != null && mounted) {
          setState(() => _videoFiles.add(file));
        }
      }
    }
  }

  Future<void> _pickPictures() async {
    final files = await _storageService.pickMultipleImages();
    if (files.isNotEmpty && mounted) {
      setState(() => _pictureFiles.addAll(files));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: Text(widget.course != null ? 'Edit Course' : 'Add Course'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Course Title',
                icon: Icons.title,
                validator: (v) => Validators.required(v, 'Course title'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => Validators.required(v, 'Description'),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Difficulty',
                value: _selectedDifficulty,
                items: ['Beginner', 'Intermediate', 'Advanced'],
                onChanged: (v) => setState(() => _selectedDifficulty = v!),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _instructorController,
                label: 'Instructor Name',
                icon: Icons.person,
                validator: (v) => Validators.required(v, 'Instructor name'),
              ),
              const SizedBox(height: 16),
              
              // Thumbnail Section
              Text(
                'Thumbnail',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _thumbnailUrlController,
                      label: 'Thumbnail URL (optional if uploading)',
                      icon: Icons.link,
                      validator: (v) => Validators.url(v, required: false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickThumbnail,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_thumbnailFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'File selected: ${_thumbnailFile!.path.split('/').last}',
                          style: TextStyle(fontSize: 12, color: Colors.green[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _thumbnailFile = null),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              
              // Video URLs Section
              _buildMediaSection(
                title: 'Videos',
                controllers: _videoUrlControllers,
                icon: Icons.video_library,
                videoFiles: _videoFiles,
                onAdd: () {
                  setState(() {
                    _videoUrlControllers.add(TextEditingController());
                  });
                },
                onRemove: (index) {
                  if (_videoUrlControllers.length > 1) {
                    setState(() {
                      _videoUrlControllers[index].dispose();
                      _videoUrlControllers.removeAt(index);
                    });
                  }
                },
                onUpload: _pickVideos,
                onRemoveFile: (index) {
                  setState(() => _videoFiles.removeAt(index));
                },
              ),
              const SizedBox(height: 16),
              
              // Picture URLs Section
              _buildMediaSection(
                title: 'Pictures',
                controllers: _pictureUrlControllers,
                icon: Icons.photo_library,
                pictureFiles: _pictureFiles,
                onAdd: () {
                  setState(() {
                    _pictureUrlControllers.add(TextEditingController());
                  });
                },
                onRemove: (index) {
                  if (_pictureUrlControllers.length > 1) {
                    setState(() {
                      _pictureUrlControllers[index].dispose();
                      _pictureUrlControllers.removeAt(index);
                    });
                  }
                },
                onUpload: _pickPictures,
                onRemoveFile: (index) {
                  setState(() => _pictureFiles.removeAt(index));
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _durationController,
                      label: 'Duration (minutes)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.integer(v, required: true, min: 1, max: 10000),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lessonCountController,
                      label: 'Lesson Count',
                      icon: Icons.library_books,
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.integer(v, required: true, min: 1, max: 1000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Free Course'),
                value: _isFree,
                onChanged: (v) => setState(() => _isFree = v),
              ),
              if (!_isFree) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Price',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (v) => _isFree ? null : Validators.price(v, required: true),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isUploading && _uploadProgress > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: _uploadProgress,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    if (_uploadStatus.isNotEmpty)
                                      Text(
                                        _uploadStatus,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isUploading ? 'Uploading...' : 'Saving...',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Text(
                          widget.course != null ? 'Update Course' : 'Create Course',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMediaSection({
    required String title,
    required List<TextEditingController> controllers,
    required IconData icon,
    required VoidCallback onAdd,
    required Function(int) onRemove,
    List<File>? videoFiles,
    List<File>? pictureFiles,
    VoidCallback? onUpload,
    Function(int)? onRemoveFile,
  }) {
    final files = videoFiles ?? pictureFiles ?? [];
    final isVideo = videoFiles != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onUpload != null)
                  TextButton.icon(
                    onPressed: _isLoading ? null : onUpload,
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: Text(isVideo ? 'Upload Video' : 'Upload Images'),
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: onAdd,
                  color: kPrimaryColor,
                  tooltip: 'Add URL field',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Show uploaded files
        if (files.isNotEmpty)
          ...files.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileProgress = _fileProgress[index] ?? 0.0;
            final isUploading = _isUploading && fileProgress < 1.0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUploading ? Colors.blue[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUploading ? Colors.blue[200]! : Colors.green[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isUploading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              value: fileProgress,
                              strokeWidth: 2,
                              color: Colors.blue[700],
                            ),
                          )
                        else
                          Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file.path.split('/').last,
                            style: TextStyle(
                              fontSize: 12,
                              color: isUploading ? Colors.blue[900] : Colors.green[900],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!_isLoading)
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            color: Colors.red,
                            onPressed: () => onRemoveFile?.call(index),
                          ),
                      ],
                    ),
                    if (isUploading && fileProgress > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: fileProgress,
                              backgroundColor: Colors.blue[100],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(fileProgress * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        
        // URL input fields
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: '${title} URL ${index + 1} (optional)',
                      prefixIcon: Icon(icon),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) => Validators.url(v, required: false),
                  ),
                ),
                if (controllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemove(index),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

