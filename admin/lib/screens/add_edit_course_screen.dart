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
  final _formKey = GlobalKey<FormState>(); // Form validation key
  final _adminService = AdminService(); // Service instance
  
  // Form controllers
  final _titleController = TextEditingController(); // Course title controller
  final _descriptionController = TextEditingController(); // Course description controller
  final _instructorController = TextEditingController(); // Instructor name controller
  final _thumbnailUrlController = TextEditingController(); // Thumbnail URL controller
  final _durationController = TextEditingController(); // Duration controller
  final _lessonCountController = TextEditingController(); // Lesson count controller
  final _priceController = TextEditingController(); // Price controller

  // Selection state
  String _selectedCategory = 'Make Up'; // Currently selected category
  String _selectedDifficulty = 'Beginner'; // Currently selected difficulty level
  bool _isFree = false; // Whether course is free
  bool _isLoading = false; // Loading state for async operations
  List<String> _categories = ['Make Up', 'Hair Styling', 'Hair Making', 'Nail Care', 'Arts']; // Available categories

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.course != null) {
      _populateForm();
    }
  }

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
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final courseData = <String, dynamic>{
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'category': _selectedCategory,
          'difficulty': _selectedDifficulty,
          'instructor': _instructorController.text.trim(),
          'thumbnailUrl': _thumbnailUrlController.text.trim(),
          'duration': int.tryParse(_durationController.text) ?? 0,
          'lessonCount': int.tryParse(_lessonCountController.text) ?? 0,
          'isFree': _isFree,
          'price': _isFree ? null : (double.tryParse(_priceController.text) ?? 0.0),
        };
        
        if (widget.course == null) {
          courseData['createdAt'] = FieldValue.serverTimestamp();
        }
        courseData['updatedAt'] = FieldValue.serverTimestamp();

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
          setState(() => _isLoading = false);
        }
      }
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
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _thumbnailUrlController,
                label: 'Thumbnail URL',
                icon: Icons.image,
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
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Required';
                        if (int.tryParse(v!) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lessonCountController,
                      label: 'Lesson Count',
                      icon: Icons.library_books,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Required';
                        if (int.tryParse(v!) == null) return 'Invalid number';
                        return null;
                      },
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
                  validator: (v) {
                    if (!_isFree && (v?.isEmpty ?? true)) return 'Required';
                    if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                      return 'Invalid price';
                    }
                    return null;
                  },
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
                      ? const CircularProgressIndicator(color: Colors.white)
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
}

