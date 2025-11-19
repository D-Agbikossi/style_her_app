import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';

// --- PLACEHOLDER CLASSES (Based on your context) ---
// Define placeholder colors and radii
class AppTheme {
  static const Color primary = Color(0xFF5C7CEC);
  static const Color text = Colors.black87;
  static const Color softText = Colors.grey;
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
];

final List<MyCourse> ongoingCourses = [
  const MyCourse(
    id: 'C201',
    title: 'Advanced Styling',
    category: 'Hair Styling',
    duration: '2 Hrs 46 Mins',
    rating: 4.6,
    isCompleted: false,
  ),
  const MyCourse(
    id: 'C202',
    title: 'Color Theory',
    category: 'Hair Coloring',
    duration: '1 Hrs 58 Mins',
    rating: 4.9,
    isCompleted: false,
  ),
];

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    // Initial index set to 0 to default to 'Completed' (based on the design image)
    _tab = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
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
          preferredSize: const Size.fromHeight(
            64,
          ), // Increased height for better styling
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.text,
              tabs: const [
                Tab(text: 'Completed'),
                Tab(text: 'Ongoing'),
              ],
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

  // 🌟 MODIFIED: Course Card Widget to handle Completed/Ongoing state and navigation 🌟
  Widget _buildCourseCard({
    required MyCourse course,
    required double progress,
    required bool isCompleted,
  }) {
    // Define the distinct background color for completed courses (light green/yellow tint)
    final Color cardBackgroundColor = isCompleted
        ? const Color(0xFFF0F8E8)
        : Colors.white;

    return Container(
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
            height: 58,
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
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                    Text(
                      '| ${course.duration}',
                      style: const TextStyle(
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
                      onPressed: () {
                        // 🌟 NAVIGATION TO CERTIFICATE SCREEN 🌟
                        Navigator.of(context).pushNamed(
                          AppRoutes.certificate,
                          arguments:
                              course.id, // Pass course ID to certificate page
                        );
                      },
                      child: Text(
                        'VIEW CERTIFICATE',
                        style: TextStyle(
                          color: AppTheme.primary,
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
    );
  }

  // 🌟 MODIFIED: Course List Widget to use the new model 🌟
  Widget _buildCourseList(List<MyCourse> courses, {bool completed = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        // Hardcode mock progress for ongoing courses for demonstration
        final double progressValue = index == 0
            ? 0.56
            : index == 1
            ? 0.29
            : 0.75;

        return _buildCourseCard(
          course: course,
          progress: completed ? 1.0 : progressValue,
          isCompleted: completed,
        );
      },
    );
  }
}
