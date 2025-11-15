import 'package:flutter/material.dart';

// --- MAIN APPLICATION WIDGET ---
class CourseDetailsApp extends StatelessWidget {
  const CourseDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Details',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(color: Colors.transparent, elevation: 0),
      ),
      home: const CourseDetailsScreen(),
    );
  }
}

// --- 1. COURSE DETAILS SCREEN (MAIN LAYOUT) ---
class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = [Tab(text: 'About'), Tab(text: 'Curriculum')];

    // Define consistent styling elements
    final Color primaryColor = Colors.blue.shade700;
    const BorderRadius roundedBorder28 = BorderRadius.all(Radius.circular(28));

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // --- 1. Collapsible Video Header ---
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {},
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Video Placeholder
                      Container(color: Colors.black),
                      // Play Button
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // --- 2. Course Info and TabBar ---
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(130.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Top Info Row (Category & Rating)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hair Making',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '4.2',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.star, color: primaryColor, size: 16),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Course Title
                        const Text(
                          'Introduction to Hair Mak...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Stats Row (Videos & Hours)
                        Row(
                          children: [
                            const Icon(
                              Icons.videocam,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '21 Videos |',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '42 Hours',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // TabBar
                        TabBar(
                          tabs: tabs,
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          // --- 3. TabBarView Content ---
          body: TabBarView(
            children: [
              AboutTabView(primaryColor: primaryColor),
              CurriculumTabView(primaryColor: primaryColor),
            ],
          ),
        ),
        // --- 4. Fixed Bottom Enrollment Bar ---
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: roundedBorder28,
                    ),
                  ),
                  child: const Text(
                    'Enroll Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: roundedBorder28,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- 2. ABOUT TAB VIEW ---
// ------------------------------------------------------------------

class AboutTabView extends StatelessWidget {
  final Color primaryColor;

  const AboutTabView({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Course Description ---
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. Read More',
            style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Read More',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 32),

          // --- Instructor Section ---
          const Text(
            'Instructor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Image Placeholder
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brunelle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Hair Dresser',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.message, color: primaryColor), // Message icon
            ],
          ),
          const Divider(height: 32),

          // --- What You'll Get Section ---
          const Text(
            "What You'll Get",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(primaryColor, Icons.description, '25 Lessons'),
          _buildFeatureRow(
            primaryColor,
            Icons.devices,
            'Access Mobile, Desktop',
          ),
          _buildFeatureRow(primaryColor, Icons.speed, 'Beginner Level'),
          _buildFeatureRow(
            primaryColor,
            Icons.watch_later_outlined,
            'Lifetime Access',
          ),
          _buildFeatureRow(
            primaryColor,
            Icons.military_tech,
            'Certificate of Completion',
          ),
          const Divider(height: 32),

          // --- Reviews Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'SEE ALL',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildReviewCard(
            primaryColor,
            'Will',
            'This course has been very useful. Mentor was well spoken totally loved it.',
            4.5,
            578,
            Colors.blue.shade300,
          ),
          _buildReviewCard(
            primaryColor,
            'Martha E. Thompson',
            'This course has been very useful. Mentor was well spoken totally loved it. It had fun sessions as well.',
            4.5,
            578,
            Colors.amber,
          ),
          const SizedBox(height: 100), // Padding for the bottom bar
        ],
      ),
    );
  }

  Widget _buildFeatureRow(Color color, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    Color primaryColor,
    String name,
    String comment,
    double rating,
    int likes,
    Color avatarColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Image Placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 12),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Rating Bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                // Likes and Time
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red.shade600, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      likes.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '2 Weeks Ago',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
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

// ------------------------------------------------------------------
// --- 3. CURRICULUM TAB VIEW ---
// ------------------------------------------------------------------

class CurriculumTabView extends StatelessWidget {
  final Color primaryColor;

  CurriculumTabView({super.key, required this.primaryColor});

  final List<Map<String, dynamic>> curriculum = const [
    {
      'type': 'section',
      'title': 'Section 01 - Introducation',
      'duration': '25 Mins',
    },
    {
      'type': 'lesson',
      'title': 'Why Using Graphic De..',
      'duration': '15 Mins',
      'number': 1,
    },
    {
      'type': 'lesson',
      'title': 'Setup Your Graphic De..',
      'duration': '10 Mins',
      'number': 2,
    },
    {
      'type': 'section',
      'title': 'Section 02 - Graphic Design',
      'duration': '55 Mins',
    },
    {
      'type': 'lesson',
      'title': 'Why Using Graphic De..',
      'duration': '15 Mins',
      'number': 1,
    },
    {
      'type': 'lesson',
      'title': 'Setup Your Graphic De..',
      'duration': '10 Mins',
      'number': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 100.0,
        left: 16.0,
        right: 16.0,
      ),
      itemCount: curriculum.length,
      itemBuilder: (context, index) {
        final item = curriculum[index];
        if (item['type'] == 'section') {
          return _buildSectionHeader(
            item['title'] as String,
            item['duration'] as String,
          );
        } else {
          return _buildLessonRow(
            primaryColor,
            item['number'] as int,
            item['title'] as String,
            item['duration'] as String,
          );
        }
      },
    );
  }

  Widget _buildSectionHeader(String title, String duration) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            duration,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonRow(
    Color color,
    int number,
    String title,
    String duration,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Lesson Number Circle
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Lesson Title and Duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Play Button
          Icon(Icons.play_circle_fill, color: color, size: 28),
        ],
      ),
    );
  }
}
