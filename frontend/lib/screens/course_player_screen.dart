/**
 * Course Player Screen - Full Screen Video Playback
 * * This screen provides full-screen video playback for course lessons with:
 * - Full-screen video player
 * - Course information
 * - Bottom navigation tabs: Overview, Lessons, Resources, Reviews
 * - Lesson navigation
 * - Progress tracking
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/repositories/course_repository.dart';
import '../models/course.dart';
import '../widgets/video_player_widget.dart';
import '../routes.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1);

/**
 * Course Player Screen
 * Displays full-screen video player with course navigation
 */
class CoursePlayerScreen extends StatefulWidget {
  final String courseId;
  final int? initialVideoIndex;

  const CoursePlayerScreen({
    super.key,
    required this.courseId,
    this.initialVideoIndex,
  });

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentVideoIndex = 0;
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentVideoIndex = widget.initialVideoIndex ?? 0;
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );
      // Some provider implementations return the Course, others return void and store the result internally.
      // Await the fetch call first.
      await courseProvider.fetchCourseById(widget.courseId);

      // Determine the fetched course: prefer provider-held course instances or provider getters (some providers return void).
      Course? fetchedCourse;
      try {
        final dynamic dynProvider = courseProvider;
        if (dynProvider.currentCourse is Course) {
          fetchedCourse = dynProvider.currentCourse as Course;
        } else if (dynProvider.course is Course) {
          fetchedCourse = dynProvider.course as Course;
        } else if (dynProvider.getCourseById != null) {
          // If a getter/method exists, try to call it.
          try {
            final maybeCourse = dynProvider.getCourseById(widget.courseId);
            if (maybeCourse is Course) fetchedCourse = maybeCourse;
          } catch (_) {
            // ignore failures from dynamic call
          }
        }
      } catch (_) {
        // ignore any reflection/dynamic errors and leave fetchedCourse as null
      }

      if (mounted) {
        setState(() {
          _course = fetchedCourse;
          _isLoading = false;
          // Ensure video index is valid
          if (_course != null &&
              _currentVideoIndex >= _course!.videoUrls.length) {
            _currentVideoIndex = 0;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading course: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectVideo(int index) {
    if (_course != null && index >= 0 && index < _course!.videoUrls.length) {
      setState(() {
        _currentVideoIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_course == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'Course not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player Section
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black, // Ensure background is black
                width: double.infinity,
                child: _course!.videoUrls.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white30,
                          size: 60,
                        ),
                      )
                    : VideoPlayerWidget(
                        // CRITICAL FIX: Adding a Key forces the widget to rebuild
                        // completely when the URL changes, preventing "stuck" players.
                        key: ValueKey(_course!.videoUrls[_currentVideoIndex]),
                        videoUrl: _course!.videoUrls[_currentVideoIndex],
                        autoPlay: true,
                        showControls: true,
                      ),
              ),
            ),

            // Course Info and Tabs Section
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Course Title and Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _course!.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                _course!.instructor,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _course!.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Continue Learning - could track progress here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Progress saved'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Continue Learning',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: kPrimaryColor,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Lessons'),
                        Tab(text: 'Resources'),
                        Tab(text: 'Reviews'),
                      ],
                    ),

                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(_course!),
                          _buildLessonsTab(_course!),
                          _buildResourcesTab(_course!),
                          _buildReviewsTab(_course!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Course course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            course.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Text(
            "What you'll learn",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(Icons.check_circle, 'Learn from industry experts'),
          _buildFeatureItem(Icons.check_circle, 'Master beauty techniques'),
          _buildFeatureItem(Icons.check_circle, 'Get hands-on experience'),
          _buildFeatureItem(Icons.check_circle, 'Build your portfolio'),
        ],
      ),
    );
  }

  Widget _buildLessonsTab(Course course) {
    if (course.videoUrls.isEmpty) {
      return const Center(child: Text('No lessons available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: course.videoUrls.length,
      itemBuilder: (context, index) {
        final isSelected = index == _currentVideoIndex;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryColor.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kPrimaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              'Lesson ${index + 1}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? kPrimaryColor : Colors.black87,
              ),
            ),
            trailing: Icon(
              isSelected ? Icons.play_circle_filled : Icons.play_circle_outline,
              color: isSelected ? kPrimaryColor : Colors.grey,
            ),
            onTap: () => _selectVideo(index),
          ),
        );
      },
    );
  }

  Widget _buildResourcesTab(Course course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Resources',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildResourceItem(
            Icons.description,
            'Course Materials',
            'Download PDF',
          ),
          _buildResourceItem(Icons.image, 'Reference Images', 'View Gallery'),
          _buildResourceItem(Icons.link, 'External Links', 'Visit Resources'),
          _buildResourceItem(Icons.quiz, 'Practice Quizzes', 'Take Quiz'),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(Course course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to review screen
                  Navigator.of(context).pushNamed(
                    AppRoutes.courseDetail,
                    arguments: widget.courseId,
                  );
                },
                child: const Text('Write Review'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sample reviews - in production, fetch from database
          _buildReviewItem(
            'Sarah M.',
            5,
            'Amazing course! Very detailed and helpful.',
          ),
          _buildReviewItem('Jane D.', 4, 'Great content, learned a lot.'),
          _buildReviewItem('Mary K.', 5, 'Highly recommend this course!'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPrimaryColor.withOpacity(0.2),
                child: Text(
                  name[0],
                  style: const TextStyle(color: kPrimaryColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
