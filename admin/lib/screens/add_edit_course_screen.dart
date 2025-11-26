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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model imports
import '../models/course.dart';

// Service imports
import '../services/admin_service.dart';

// Utils imports
import '../utils/validators.dart';
import '../utils/error_handler.dart';

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
  
  // Note: File uploads removed - using URL-only approach

  // Selection state
  String _selectedCategory = 'Make Up';
  String _selectedDifficulty = 'Beginner';
  bool _isFree = false;
  bool _isLoading = false;
  List<String> _categories = ['Make Up', 'Hair Styling', 'Hair Making', 'Nail Care', 'Arts'];


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

  /// Save course to Firestore with URL validation
  /// Handles both create and update operations
  Future<void> _saveCourse() async {
    // Validate form fields first
    if (!_formKey.currentState!.validate()) return;
    
    // Thumbnail URL is required (no file upload fallback)
    if (_thumbnailUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a thumbnail URL'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate thumbnail URL format (must be valid HTTP/HTTPS URL)
    final thumbnailUrlError = Validators.url(_thumbnailUrlController.text.trim());
    if (thumbnailUrlError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid thumbnail URL: $thumbnailUrlError'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String thumbnailUrl = _thumbnailUrlController.text.trim();

      // Collect and validate video URLs (filter empty, validate format)
      final videoUrls = <String>[];
      for (int i = 0; i < _videoUrlControllers.length; i++) {
        final controller = _videoUrlControllers[i];
        final url = controller.text.trim();
        if (url.isNotEmpty) {
          // Validate each URL format before adding
          final error = Validators.url(url);
          if (error != null) {
            // Show user-friendly error with video number and specific issue
            final videoNumber = i + 1;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invalid Video URL #$videoNumber',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(error),
                      if (url.length <= 60) ...[
                        const SizedBox(height: 4),
                        Text(
                          'URL: $url',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 6),
                ),
              );
            }
            throw Exception('Invalid video URL #$videoNumber: $error');
          }
          videoUrls.add(url);
        }
      }
      
      // Collect and validate picture URLs (filter empty, validate format)
      final pictureUrls = <String>[];
      for (int i = 0; i < _pictureUrlControllers.length; i++) {
        final controller = _pictureUrlControllers[i];
        final url = controller.text.trim();
        if (url.isNotEmpty) {
          // Validate each URL format before adding
          final error = Validators.url(url);
          if (error != null) {
            // Show user-friendly error with image number and specific issue
            final imageNumber = i + 1;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invalid Image URL #$imageNumber',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(error),
                      if (url.length <= 60) ...[
                        const SizedBox(height: 4),
                        Text(
                          'URL: $url',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 6),
                ),
              );
            }
            throw Exception('Invalid picture URL #$imageNumber: $error');
          }
          pictureUrls.add(url);
        }
      }
      
      // Build course data map for Firestore
      final courseData = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'difficulty': _selectedDifficulty,
        'instructor': _instructorController.text.trim(),
        'thumbnailUrl': thumbnailUrl,
        'videoUrls': videoUrls, // List of video URLs (required)
        'pictureUrls': pictureUrls, // List of picture URLs (optional, can be empty)
        'duration': int.tryParse(_durationController.text) ?? 0, // Default to 0 if invalid
        'lessonCount': int.tryParse(_lessonCountController.text) ?? 0, // Default to 0 if invalid
        'isFree': _isFree,
        // Price is null for free courses, otherwise parse or default to 0.0
        'price': _isFree ? null : (double.tryParse(_priceController.text) ?? 0.0),
      };
      
      // Add timestamp fields
      if (widget.course == null) {
        // New course: set creation timestamp
        courseData['createdAt'] = FieldValue.serverTimestamp();
      }
      // Always update the updatedAt timestamp
      courseData['updatedAt'] = FieldValue.serverTimestamp();

      // Save to Firestore (create or update)
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
        Navigator.of(context).pop(true); // Return success to previous screen
      }
    } catch (e) {
      // Error is handled below with user-friendly message
      if (mounted) {
        // Use ErrorHandler for user-friendly error messages
        final friendlyMessage = ErrorHandler.getUserFriendlyMessage(e);
        
        // Show detailed error dialog for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error Saving Course',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(friendlyMessage),
                const SizedBox(height: 4),
                Text(
                  'Details: ${e.toString()}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      // Always reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // File upload methods removed - using URL-only approach

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
              Row(
                children: [
                  Text(
                    'Thumbnail URL',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 18),
                    color: kPrimaryColor,
                    onPressed: () => _showHostingHelpDialog(
                      context,
                      title: 'Where to Host Images',
                      content: 'Upload your thumbnail image to:\n\n'
                          '• Cloudinary (Recommended): https://cloudinary.com\n'
                          '  - Free tier: 25GB storage\n'
                          '  - Get direct URL after upload\n\n'
                          '• ImgBB: https://imgbb.com\n'
                          '  - Free, no account needed\n\n'
                          '• Imgur: https://imgur.com\n'
                          '  - Free, easy to use\n\n'
                          'Then paste the direct image URL here.',
                    ),
                    tooltip: 'Where to host images?',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _thumbnailUrlController,
                label: 'Thumbnail URL (required)',
                icon: Icons.link,
                validator: (v) => Validators.url(v, required: true),
                hintText: 'https://res.cloudinary.com/... or https://i.imgur.com/...',
              ),
              const SizedBox(height: 16),
              
              // Video URLs Section
              _buildMediaSection(
                title: 'Video URLs',
                controllers: _videoUrlControllers,
                icon: Icons.video_library,
                onAdd: () {
                  try {
                    setState(() {
                      _videoUrlControllers.add(TextEditingController());
                    });
                  } catch (e) {
                    // Handle any errors when adding a new field
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error adding video URL field: ${ErrorHandler.getUserFriendlyMessage(e)}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  }
                },
                onRemove: (index) {
                  if (_videoUrlControllers.length > 1) {
                    setState(() {
                      _videoUrlControllers[index].dispose();
                      _videoUrlControllers.removeAt(index);
                    });
                  }
                },
                showHelp: true,
                helpTitle: 'Where to Host Videos',
                helpContent: 'Upload your videos to:\n\n'
                    '• YouTube (Recommended): https://youtube.com\n'
                    '  - Free, unlimited storage\n'
                    '  - Use format: https://www.youtube.com/watch?v=VIDEO_ID\n\n'
                    '• Vimeo: https://vimeo.com\n'
                    '  - Free tier: 500MB/week\n\n'
                    '• Cloudinary: https://cloudinary.com\n'
                    '  - Free tier: 25GB storage\n\n'
                    'Then paste the video URL here.',
              ),
              const SizedBox(height: 16),
              
              // Picture URLs Section
              _buildMediaSection(
                title: 'Picture URLs',
                controllers: _pictureUrlControllers,
                icon: Icons.photo_library,
                onAdd: () {
                  try {
                    setState(() {
                      _pictureUrlControllers.add(TextEditingController());
                    });
                  } catch (e) {
                    // Handle any errors when adding a new field
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error adding image URL field: ${ErrorHandler.getUserFriendlyMessage(e)}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  }
                },
                onRemove: (index) {
                  if (_pictureUrlControllers.length > 1) {
                    setState(() {
                      _pictureUrlControllers[index].dispose();
                      _pictureUrlControllers.removeAt(index);
                    });
                  }
                },
                showHelp: true,
                helpTitle: 'Where to Host Images',
                helpContent: 'Upload your images to:\n\n'
                    '• Cloudinary (Recommended): https://cloudinary.com\n'
                    '  - Free tier: 25GB storage\n'
                    '  - Get direct URL after upload\n\n'
                    '• ImgBB: https://imgbb.com\n'
                    '  - Free, no account needed\n\n'
                    '• Imgur: https://imgur.com\n'
                    '  - Free, easy to use\n\n'
                    'Then paste the direct image URL here.',
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
                      ? Row(
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
                            const Text(
                              'Saving...',
                              style: TextStyle(fontSize: 16),
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
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
    bool showHelp = false,
    String? helpTitle,
    String? helpContent,
  }) {
    final isVideo = title.toLowerCase().contains('video');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showHelp) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 18),
                    color: kPrimaryColor,
                    onPressed: () => _showHostingHelpDialog(
                      context,
                      title: helpTitle ?? 'Where to Host Files',
                      content: helpContent ?? 'Upload your files to a hosting service and paste the URL here.',
                    ),
                    tooltip: 'Where to host files?',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: onAdd,
              color: kPrimaryColor,
              tooltip: 'Add URL field',
            ),
          ],
        ),
        const SizedBox(height: 8),
        
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
                      labelText: '${isVideo ? "Video" : "Image"} URL ${index + 1}',
                      hintText: isVideo 
                          ? 'https://www.youtube.com/watch?v=... or https://vimeo.com/...'
                          : 'https://res.cloudinary.com/... or https://i.imgur.com/...',
                      prefixIcon: Icon(icon),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) => v != null && v.trim().isNotEmpty 
                        ? Validators.url(v) 
                        : null,
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
        }),
      ],
    );
  }

  void _showHostingHelpDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: kPrimaryColor),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

