/**
 * Video Management Screen - Course Management
 * 
 * This screen handles course/video management functionality including:
 * - Display all courses with real-time updates
 * - Search and filter courses by category and mentor
 * - Create new courses
 * - Edit existing courses
 * - Delete courses with confirmation
 * - Real-time data synchronization with Firestore
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model imports
import '../models/course.dart';

// Service imports
import '../services/admin_service.dart';

// Route imports
import '../routes.dart';

// Widget imports
import '../widgets/bulk_operations_bar.dart';

// Theme imports
import '../main.dart';

/**
 * VideoScreen - Stateful widget for course management
 * Main widget for managing all courses/videos in the platform
 */
class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

/**
 * Video screen state management
 * Handles search, filtering, course operations, and UI state
 */
class _VideoScreenState extends State<VideoScreen> {
  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  
  // Bulk operations
  final Set<String> _selectedCourseIds = {};
  bool _isSelectionMode = false;
  
  // Service instance
  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _adminService.getCategoryNames();
    setState(() {
      _categories = ['All', ...categories];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleBulkDelete() async {
    if (_selectedCourseIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Courses?'),
        content: Text('Are you sure you want to delete ${_selectedCourseIds.length} course(s)? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final count = await _adminService.bulkDeleteCourses(_selectedCourseIds.toList());
        if (mounted) {
          setState(() {
            _selectedCourseIds.clear();
            _isSelectionMode = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$count course(s) deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
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
      }
    }
  }

  Future<void> _deleteCourse(String courseId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course?'),
        content: Text('Are you sure you want to delete "$title"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.deleteCourse(courseId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Course deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
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
      }
    }
  }

  void _showCourseOptions(Course course) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Course'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AdminRoutes.editCourse,
                  arguments: course,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Course', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteCourse(course.id, course.title);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: const Text(
          'Manage Videos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedCourseIds.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.checklist, color: Colors.black),
              onPressed: () {
                setState(() => _isSelectionMode = true);
              },
            ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, AdminRoutes.addCourse);
              if (result == true) {
                setState(() {}); // Refresh list
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton<String>(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCategory,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: kPrimaryColor, size: 20),
                            ],
                          ),
                        ),
                        onSelected: (value) => setState(() => _selectedCategory = value),
                        itemBuilder: (context) => _categories.map((category) {
                          return PopupMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'All';
                          _searchController.clear();
                        });
                      },
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Video List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _adminService.getCoursesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _EmptyVideoState();
                }

                final courses = snapshot.data!.docs.map((doc) {
                  return Course.fromMap(doc.id, doc.data() as Map<String, dynamic>);
                }).where((course) {
                  if (_searchController.text.isNotEmpty) {
                    if (!course.title.toLowerCase().contains(_searchController.text.toLowerCase())) {
                      return false;
                    }
                  }
                  if (_selectedCategory != 'All' && course.category != _selectedCategory) {
                    return false;
                  }
                  return true;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final isSelected = _selectedCourseIds.contains(course.id);
                    return _VideoCard(
                      course: course,
                      isSelectionMode: _isSelectionMode,
                      isSelected: isSelected,
                      onTap: _isSelectionMode
                          ? () {
                              setState(() {
                                if (isSelected) {
                                  _selectedCourseIds.remove(course.id);
                                } else {
                                  _selectedCourseIds.add(course.id);
                                }
                              });
                            }
                          : null,
                      onOptionsTap: () => _showCourseOptions(course),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BulkOperationsBar(
        selectedCount: _selectedCourseIds.length,
        onClearSelection: () {
          setState(() {
            _selectedCourseIds.clear();
            _isSelectionMode = false;
          });
        },
        onBulkDelete: _handleBulkDelete,
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Course course;
  final VoidCallback onOptionsTap;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;

  const _VideoCard({
    required this.course,
    required this.onOptionsTap,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: kPrimaryColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 96,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  image: course.thumbnailUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(course.thumbnailUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: course.thumbnailUrl.isEmpty
                    ? const Icon(Icons.videocam, color: Colors.white30, size: 30)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.instructor} • ${course.category}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelectionMode)
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? kPrimaryColor : Colors.grey,
                  size: 24,
                )
              else
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: onOptionsTap,
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${course.duration} min',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Published',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}

class _EmptyVideoState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Videos Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
