import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes.dart';

// --- PLACEHOLDER CLASSES (Based on your context) ---
// Define placeholder colors and radii
class AppTheme {
  static const Color primary = Color(0xFF5C7CEC); // A blue-purple primary color
  static const Color text = Colors.black87;
  static const Color softText = Colors.grey;
  static const Color accentGreen = Color(
    0xFFE9F5E8,
  ); // Light green background from image
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
}

// Mock ProgressBar widget
class ProgressBar extends StatelessWidget {
  final double progress;
  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.grey.shade200,
        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
      ),
    );
  }
}
// ----------------------------------------------------

// --- DATA MODEL ---
class MyCourse {
  final String id;
  final String category;
  final String title;
  final String duration;
  final double rating;
  final bool isCompleted;

  const MyCourse({
    required this.id,
    required this.category,
    required this.title,
    required this.duration,
    required this.rating,
    required this.isCompleted,
  });
}

// --- SAMPLE DATA ---
final List<MyCourse> completedCourses = [
  const MyCourse(
    id: 'C101',
    title: 'Hair Making 101',
    category: 'Hair Making',
    duration: '2 Hrs 36 Mins',
    rating: 4.2,
    isCompleted: true,
  ),
  const MyCourse(
    id: 'C102',
    title: 'Hair Making 101',
    category: 'Hair Making',
    duration: '3 Hrs 28 Mins',
    rating: 4.7,
    isCompleted: true,
  ),
  const MyCourse(
    id: 'C103',
    title: 'Hair Making 101',
    category: 'Hair Making',
    duration: '4 Hrs 05 Mins',
    rating: 4.2,
    isCompleted: true,
  ),
  const MyCourse(
    id: 'C104',
    title: 'Hair Making 101',
    category: 'Hair Making',
    duration: '5 Hrs 18 Mins',
    rating: 4.7,
    isCompleted: true,
  ),
];

List<MyCourse> ongoingCourses = [];

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _isLoading = true;

  @override
  void initState() {
    _tab = TabController(length: 2, vsync: this, initialIndex: 1); // Start with Ongoing tab
    super.initState();
    _fetchEnrollments();
  }

  Future<void> _fetchEnrollments() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('current_user') // Replace with actual user ID
          .collection('enrollments')
          .orderBy('enrolledAt', descending: true)
          .get();

      setState(() {
        ongoingCourses = snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return MyCourse(
                id: data['courseId'] ?? '',
                title: data['courseTitle'] ?? 'Unknown Course',
                category: data['courseCategory'] ?? 'General',
                duration: '2 Hrs 30 Mins', // Default duration
                rating: 4.5, // Default rating
                isCompleted: data['completed'] ?? false,
              );
            })
            .where((course) => !course.isCompleted)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffeef3ff), // light background like image
                borderRadius: BorderRadius.circular(40),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(40),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.text,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Completed'),
                  Tab(text: 'Ongoing'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCourseList(completedCourses, completed: true),
          _buildCourseList(ongoingCourses, completed: false),
        ],
      ),
    );
  }

  // 🌟 MODIFIED: Course Card Widget to handle navigation and styling 🌟
  Widget _buildCourseCard({
    required MyCourse course,
    required double progress,
    required bool isCompleted,
  }) {
    // Background color based on completion status (green tint for completed)
    final Color cardBackgroundColor = isCompleted
        ? AppTheme.accentGreen
        : Colors.white;

    // 🌟 FIX: Determine the navigation route 🌟
    // Completed goes to Certificate, Ongoing goes to Course Player
    final String route = isCompleted
        ? AppRoutes.certificate
        : AppRoutes.coursePlayer;

    // Determine the argument format (Course ID)
    final String argument = course.id;

    return GestureDetector(
      // 🌟 NAVIGATION: Handles the tap on the entire card 🌟
      onTap: () {
        Navigator.of(context).pushNamed(route, arguments: argument);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: AppTheme.radius16,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Placeholder
            Container(
              width: 78,
              height: 78, // Increased size for better fit
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Text (Orange/Red tint from design)
                  Text(
                    course.category,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating and Duration Row
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      // Separator
                      Container(width: 1, height: 14, color: Colors.grey[300]),
                      const SizedBox(width: 8),
                      Text(
                        course.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.softText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Action/Progress Section
                  if (isCompleted)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        // NOTE: Keeping this button visible but making the whole card tappable.
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.certificate,
                            arguments: course.id,
                          );
                        },
                        child: Text(
                          'VIEW CERTIFICATE',
                          style: TextStyle(
                            color: Colors
                                .green
                                .shade700, // Matching the green accent
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ProgressBar(progress: progress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(List<MyCourse> courses, {bool completed = false}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              completed ? 'No completed courses yet' : 'No ongoing courses yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enroll in courses to see them here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final double progressValue = 0.3; // Default progress for ongoing courses

        return _buildCourseCard(
          course: course,
          progress: completed ? 1.0 : progressValue,
          isCompleted: completed,
        );
      },
    );
  }
}
