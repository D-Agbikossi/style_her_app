import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes.dart';
import '../models/course.dart';

// --- Color Helpers ---
Color hexToColor(String hexCode) {
  String colorString = 'FF${hexCode.substring(1)}';
  return Color(int.parse(colorString, radix: 16));
}

// Global colors defined in main.dart (copied for self-containment)
final Color kBackgroundColor = hexToColor('#F5F9FF');
final Color kPrimaryBlue = hexToColor(
  '#2C5BB1',
); // Used for active buttons/icons
final Color kCourseCardColor =
    Colors.white; // Course cards appear white in the image

final List<String> categories = [
  'All',
  'Hair Styling',
  'Hair Making',
  'Arts',
  'Make Up',
  'Nail Care',
];

// --- Course Card Widget ---

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  // 🌟 WRAP CARD IN GESTURE DETECTOR FOR NAVIGATION 🌟
  void _navigateToCourseDetails(BuildContext context) {
    // Assuming AppRoutes.courseDetail is defined as '/course-detail'
    Navigator.of(context).pushNamed(
      AppRoutes.courseDetail,
      arguments: course.id, // Pass the unique course ID
    );
  }

  // 🌟 ENROLL FUNCTION 🌟
  Future<void> _enrollInCourse(BuildContext context, Course course) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      // Save enrollment to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc('current_user') // Replace with actual user ID
          .collection('enrollments')
          .doc(course.id)
          .set({
        'courseId': course.id,
        'courseTitle': course.title,
        'courseCategory': course.category,
        'enrolledAt': FieldValue.serverTimestamp(),
        'progress': 0.0,
        'completed': false,
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text('Enrolled in ${course.title}!'),
          backgroundColor: kPrimaryBlue,
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () => navigator.pushNamed(AppRoutes.myCourses),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to enroll: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCourseDetails(context),
      child: Card(
        elevation: 2.0,
        color: kCourseCardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Placeholder for the Course Image/Thumbnail
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black, // Placeholder black color
                  borderRadius: BorderRadius.circular(8),
                ),
                // You would add an Image.network or Image.asset here
              ),
              const SizedBox(width: 12),

              // Right: Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Category & Bookmark Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        Icon(
                          Icons.bookmark_border,
                          color: kPrimaryBlue,
                          size: 20,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Row 2: Title
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Row 3: Price
                    Text(
                      course.isFree ? 'Free' : '\$${course.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBlue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Row 4: Rating & Modules
                    Row(
                      children: [
                        // Rating Star and Value
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Separator
                        Container(
                          width: 1,
                          height: 16,
                          color: Colors.grey[300],
                        ),

                        const SizedBox(width: 12),

                        // Modules Count
                        Text(
                          '${course.lessonCount} Lessons',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Enroll Button
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          _enrollInCourse(context, course);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Enroll',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Category Chip Widget (Unchanged) ---
class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimaryBlue : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Main Popular Courses Screen Widget (Unchanged) ---
class PopularCoursesScreen extends StatefulWidget {
  const PopularCoursesScreen({super.key});

  @override
  State<PopularCoursesScreen> createState() => _PopularCoursesScreenState();
}

class _PopularCoursesScreenState extends State<PopularCoursesScreen> {
  String _selectedCategory = categories.first;
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _courses = snapshot.docs
            .map((doc) => Course.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'All') {
      return _courses;
    }
    return _courses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Popular Courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Category Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: categories.map((category) {
                  return CategoryChip(
                    category: category,
                    isSelected: category == _selectedCategory,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // 2. Course List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCourses.isEmpty
                    ? const Center(child: Text('No courses found'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = _filteredCourses[index];
                          return CourseCard(
                            course: course,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
