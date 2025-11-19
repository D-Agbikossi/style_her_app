import 'package:flutter/material.dart';
// Import the Mentor model and sample data
import 'top_mentors_screen.dart'; // Assuming Mentor and sampleMentors are here

// --- HELPER FUNCTION ---
// Function to simulate fetching mentor data based on ID
Mentor? _findMentorById(String id) {
  try {
    // Uses the sampleMentors list defined in top_mentors_screen.dart
    return sampleMentors.firstWhere((m) => m.id == id);
  } catch (e) {
    return null; // Return null if not found
  }
}

// --- 1. MENTOR PROFILE SCREEN (MAIN LAYOUT) ---
class MentorProfileScreen extends StatelessWidget {
  // ACCEPT MENTOR ID PASSED FROM ROUTE
  final String mentorId;

  const MentorProfileScreen({super.key, required this.mentorId});

  @override
  Widget build(BuildContext context) {
    // Fetch the mentor data based on the passed ID
    final Mentor? mentor = _findMentorById(mentorId);
    final Color primaryColor = Colors.blue.shade700;

    if (mentor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Mentor profile not found.')),
      );
    }

    const List<Tab> _tabs = [Tab(text: 'Courses'), Tab(text: 'Ratings')];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // --- Sliver AppBar for Profile Header ---
            SliverAppBar(
              // FIX: Increase expandedHeight aggressively to resolve overflow (370 -> 400)
              expandedHeight: 400.0,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(), // Go back
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Padding(
                  // Adjust padding to match the PreferredSize height (130)
                  padding: const EdgeInsets.only(bottom: 130),
                  // PASS THE FOUND MENTOR DATA
                  child: ProfileHeader(mentor: mentor),
                ),
              ),
              bottom: PreferredSize(
                // Height of the bottom section (Bio + Tabs)
                preferredSize: const Size.fromHeight(130.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Bio/Quote Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                        child: Text(
                          "\"${mentor.bio}\"", // USE MENTOR BIO
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // TabBar for switching views
                      TabBar(
                        tabs: _tabs,
                        labelColor: primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3.0,
                      ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                        color: Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- SliverList for TabBarView Content ---
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  const CoursesView(),
                  RatingsView(
                    primaryColor: primaryColor,
                  ), // Pass color for styling
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. PROFILE HEADER WIDGET ---
class ProfileHeader extends StatelessWidget {
  final Mentor mentor;
  const ProfileHeader({super.key, required this.mentor});

  // Helper method for the stats row
  Widget _buildStatColumn(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper method for the divider between stats
  Widget _buildStatDivider() {
    return Container(height: 20, width: 1, color: Colors.grey.shade300);
  }

  // BUILD METHOD FOR THE FOLLOW/MESSAGE ACTION BUTTONS
  Widget _buildActionButtons(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 8),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: Colors.blue.shade50,
              ),
              child: const Text(
                'Follow',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 32),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Message',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade700;

    return Container(
      // FIX: Adjusted top padding slightly
      padding: const EdgeInsets.only(top: 60),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // Profile Image Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          // Mentor Name
          Text(
            mentor.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          // Job Title/Workplace
          Text(
            "${mentor.specialty} at ${mentor.workplace}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStatColumn(mentor.courses.toString(), 'Courses'),
              _buildStatDivider(),
              _buildStatColumn(mentor.students.toString(), 'Students'),
              _buildStatDivider(),
              _buildStatColumn("${mentor.ratings.toInt()}+", 'Ratings'),
            ],
          ),
          const SizedBox(height: 12),
          // CALL THE BUTTONS METHOD HERE
          _buildActionButtons(primaryColor),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// --- 3. COURSES TAB VIEW (Fixed data placeholder) ---
class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  final List<Map<String, String>> courses = const [
    {
      'title': 'Hair Making Fundamen...',
      'category': 'Hair Making',
      'price': '\$30',
      'rating': '4.2',
      'modules': '8 Modules',
    },
    {
      'title': 'Types of Hair Styles',
      'category': 'Hair Making',
      'price': '\$30',
      'rating': '4.2',
      'modules': '12 Modules',
    },
    {
      'title': 'Advanced Braiding Techniques',
      'category': 'Hair Making',
      'price': '\$45',
      'rating': '4.5',
      'modules': '10 Modules',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // FIX: Set primary: false to resolve RenderFlex overflow
    return ListView.separated(
      primary: false,
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 32, thickness: 0.5),
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseListItem(
          title: course['title']!,
          category: course['category']!,
          price: course['price']!,
          rating: course['rating']!,
          modules: course['modules']!,
        );
      },
    );
  }
}

// Course List Item (Simplified for brevity)
class CourseListItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String rating;
  final String modules;

  const CourseListItem({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Image Placeholder
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(right: 12),
        ),
        // Course Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '| $modules',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- 4. RATINGS TAB VIEW (UPDATED) ---
class RatingsView extends StatelessWidget {
  RatingsView({super.key, required this.primaryColor});

  final Color primaryColor;

  final List<Map<String, dynamic>> ratings = const [
    {
      'name': 'Mary',
      'comment':
          'This course has been very useful. Mentor was well spoken totally loved it.',
      'score': 4.7,
      'likes': 350,
      'time': '2 Weeks Ago',
    },
    {
      'name': 'James',
      'comment':
          'This course has been very useful. Mentor was well spoken totally loved it.',
      'score': 4.5,
      'likes': 760,
      'time': '1 Week Ago',
    },
    {
      'name': 'Sarah',
      'comment': 'Learned a lot! The pacing was perfect and easy to follow.',
      'score': 4.9,
      'likes': 120,
      'time': '1 Day Ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // FIX: Set primary: false to resolve RenderFlex overflow
    return ListView.separated(
      primary: false,
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 20,
      ), // Added bottom padding
      itemCount: ratings.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: Color(0xFFE0E0E0),
      ),
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return RatingListItem(
          primaryColor: primaryColor,
          name: rating['name'] as String,
          comment: rating['comment'] as String,
          score: rating['score'] as double,
          likes: rating['likes'] as int,
          time: rating['time'] as String,
        );
      },
    );
  }
}

// UPDATED Rating List Item
class RatingListItem extends StatelessWidget {
  final Color primaryColor;
  final String name;
  final String comment;
  final double score;
  final int likes;
  final String time;

  const RatingListItem({
    super.key,
    required this.primaryColor,
    required this.name,
    required this.comment,
    required this.score,
    required this.likes,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Image Placeholder
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black, // Placeholder
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
                            score.toString(),
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
                // Comment
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                // Likes and Time
                Row(
                  children: [
                    // Heart Icon and Like Count
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
                    // Time Since Posted
                    Text(
                      time,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
