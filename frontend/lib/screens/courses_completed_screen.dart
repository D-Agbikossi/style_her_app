import 'package:flutter/material.dart';

// --- Theme Placeholder (Based on previous context) ---
// Define placeholder colors and radii to make the code runnable
class AppTheme {
  static const Color primary = Color(
    0xFF5C7CEC,
  ); // A light blue/purple for primary actions
  static const Color softText = Colors.grey;
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
}

// --- MAIN APPLICATION WIDGET ---
class MyCoursesApp extends StatelessWidget {
  const MyCoursesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Courses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFFF7F8FA,
        ), // Light grey background
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const MyCoursesScreen(),
    );
  }
}

// --- 1. MAIN SCREEN WITH TAB BAR ---
class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Mock Data for courses
  final List<Map<String, dynamic>> completedCourses = const [
    {
      'title': 'Hair Making 101',
      'category': 'Hair Making',
      'rating': 4.2,
      'duration': '2 Hrs 36 Mins',
      'completed': true,
    },
    {
      'title': 'Hair Making 102',
      'category': 'Hair Making',
      'rating': 4.7,
      'duration': '3 Hrs 28 Mins',
      'completed': true,
    },
    {
      'title': 'Hair Making 103',
      'category': 'Hair Making',
      'rating': 4.2,
      'duration': '4 Hrs 05 Mins',
      'completed': true,
    },
    {
      'title': 'Hair Making 104',
      'category': 'Hair Making',
      'rating': 4.7,
      'duration': '5 Hrs 18 Mins',
      'completed': true,
    },
  ];

  final List<Map<String, dynamic>> ongoingCourses = const [
    {
      'title': 'Advanced Styling',
      'category': 'Hair Making',
      'rating': 4.5,
      'duration': '4 Hrs 00 Mins',
      'progress': 0.56,
    },
    {
      'title': 'Color Theory',
      'category': 'Hair Coloring',
      'rating': 4.9,
      'duration': '3 Hrs 15 Mins',
      'progress': 0.29,
    },
  ];

  @override
  void initState() {
    _tab = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    ); // Start on Completed tab (index 0)
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
          onPressed: () {},
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
              color: const Color(
                0xFFE5E7EB,
              ), // Light grey background for the tab area
              borderRadius: BorderRadius.circular(28),
            ),
            child: TabBar(
              controller: _tab,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme
                    .primary, // Using the primary color for the selected tab
                borderRadius: BorderRadius.circular(28),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(
                  child: Text(
                    'Completed',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'Ongoing',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
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

  Widget _buildCourseList(
    List<Map<String, dynamic>> courses, {
    bool completed = false,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return MyCourseCard(
          title: course['title'] as String,
          category: course['category'] as String,
          rating: course['rating'] as double,
          duration: course['duration'] as String,
          isCompleted: completed,
          // Progress is only included for ongoing courses
          progress: completed ? 1.0 : (course['progress'] as double? ?? 0.0),
        );
      },
    );
  }
}

// --- 2. REUSABLE COURSE CARD WIDGET ---
class MyCourseCard extends StatelessWidget {
  final String title;
  final String category;
  final double rating;
  final String duration;
  final bool isCompleted;
  final double progress; // Only used for Ongoing view

  const MyCourseCard({
    super.key,
    required this.title,
    required this.category,
    required this.rating,
    required this.duration,
    required this.isCompleted,
    this.progress = 0.0,
  });

  // Helper method to build the certificate button
  Widget _buildCertificateButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Handle certificate view
      },
      child: Text(
        'VIEW CERTIFICATE',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Helper method for the progress bar (similar to the one in previous context)
  Widget _buildProgressBar(double progress) {
    // Only used for the Ongoing tab
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Background color based on completion status
    final Color cardBackgroundColor = isCompleted
        ? const Color(0xFFE9F5E5)
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            width: 78,
            height: 78, // Increased height to accommodate the content better
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
                // Category
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                // Rating and Duration Row
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('|', style: TextStyle(color: AppTheme.softText)),
                    const SizedBox(width: 8),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.softText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Action/Progress Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isCompleted)
                      _buildCertificateButton(context)
                    else
                      Expanded(
                        child: _buildProgressBar(progress),
                      ), // Show progress bar for ongoing
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
