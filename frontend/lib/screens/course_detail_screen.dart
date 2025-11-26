/**
 * Course Detail Screen
 * 
 * Displays comprehensive course information with:
 * - Video player for course videos
 * - Image gallery for course pictures
 * - Course details, instructor info, curriculum
 */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/image_gallery_widget.dart';
import '../models/course.dart';
import '../services/enrollment_service.dart';
import '../constants/app_constants.dart';
import '../repositories/course_repository.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String? courseId;

  const CourseDetailsScreen({super.key, this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  int _selectedVideoIndex = 0;
  bool _isEnrolled = false;
  bool _isEnrolling = false;
  final EnrollmentService _enrollmentService = EnrollmentService();

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _checkEnrollmentStatus();
    }
  }

  Future<void> _checkEnrollmentStatus() async {
    if (widget.courseId == null) return;
    try {
      final enrolled = await _enrollmentService.isEnrolled(widget.courseId!);
      if (mounted) {
        setState(() {
          _isEnrolled = enrolled;
        });
      }
    } catch (e) {
      // Silently fail - enrollment check is not critical
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final course = courseProvider.currentCourse;
    final primaryColor = Colors.blue.shade700;
    const roundedBorder28 = BorderRadius.all(Radius.circular(28));

    if (courseProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (courseProvider.error != null || course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                courseProvider.error ?? 'Course not found',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 350.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: _buildVideoHeader(course, primaryColor),
                ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              course.category,
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  course.rating.toStringAsFixed(1),
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
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.videocam,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.videoUrls.length} Videos |',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.duration} Minutes',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TabBar(
                          tabs: const [
                            Tab(text: 'About'),
                            Tab(text: 'Curriculum'),
                          ],
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
          body: TabBarView(
            children: [
              AboutTabView(course: course, primaryColor: primaryColor),
              CurriculumTabView(
                course: course,
                primaryColor: primaryColor,
                onVideoSelect: (index) {
                  setState(() {
                    _selectedVideoIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
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
                  onPressed: _isEnrolled || _isEnrolling
                      ? null
                      : () => _handleEnrollment(course, primaryColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEnrolled ? Colors.grey : primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: roundedBorder28,
                    ),
                  ),
                  child: _isEnrolling
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _isEnrolled
                              ? 'Enrolled'
                              : course.isFree
                              ? 'Enroll Free'
                              : '\$${course.price?.toStringAsFixed(2)} Enroll',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildVideoHeader(Course course, Color primaryColor) {
    if (course.videoUrls.isEmpty) {
      return Container(
        color: Colors.black,
        child: course.thumbnailUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: course.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.videocam, color: Colors.white30, size: 60),
                ),
              )
            : const Center(
                child: Icon(Icons.videocam, color: Colors.white30, size: 60),
              ),
      );
    }

    // Ensure selected index is within bounds
    final validIndex = _selectedVideoIndex < course.videoUrls.length
        ? _selectedVideoIndex
        : 0;

    return VideoPlayerWidget(
      videoUrl: course.videoUrls[validIndex],
      autoPlay: false,
      showControls: true,
    );
  }

  Future<void> _handleEnrollment(Course course, Color primaryColor) async {
    if (widget.courseId == null) return;

    setState(() {
      _isEnrolling = true;
    });

    try {
      final success = await _enrollmentService.enrollInCourse(widget.courseId!);

      if (mounted) {
        setState(() {
          _isEnrolling = false;
          if (success) {
            _isEnrolled = true;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? AppConstants.enrollmentSuccess
                  : 'You are already enrolled in this course.',
            ),
            backgroundColor: success ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle enrollment errors
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });

        // Show user-friendly error message (remove "Exception: " prefix)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to enroll: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// ------------------------------------------------------------------
// --- ABOUT TAB VIEW ---
// ------------------------------------------------------------------

class AboutTabView extends StatelessWidget {
  final course;
  final Color primaryColor;

  const AboutTabView({
    super.key,
    required this.course,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Description
          Text(
            course.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 32),

          // Image Gallery
          if (course.pictureUrls.isNotEmpty) ...[
            const Text(
              'Course Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ImageGalleryWidget(
              imageUrls: course.pictureUrls,
              crossAxisCount: 2,
              spacing: 8.0,
              aspectRatio: 1.0,
            ),
            const Divider(height: 32),
          ],

          // Instructor Section
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.instructor,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Instructor',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.message, color: primaryColor),
            ],
          ),
          const Divider(height: 32),

          // What You'll Get Section
          const Text(
            "What You'll Get",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            primaryColor,
            Icons.description,
            '${course.lessonCount} Lessons',
          ),
          _buildFeatureRow(
            primaryColor,
            Icons.devices,
            'Access Mobile, Desktop',
          ),
          _buildFeatureRow(
            primaryColor,
            Icons.speed,
            '${course.difficulty} Level',
          ),
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
          const SizedBox(height: 100),
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
}

// ------------------------------------------------------------------
// --- CURRICULUM TAB VIEW ---
// ------------------------------------------------------------------

class CurriculumTabView extends StatelessWidget {
  final course;
  final Color primaryColor;
  final Function(int) onVideoSelect;

  const CurriculumTabView({
    super.key,
    required this.course,
    required this.primaryColor,
    required this.onVideoSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (course.videoUrls.isEmpty) {
      return const Center(child: Text('No videos available for this course'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 100.0,
        left: 16.0,
        right: 16.0,
      ),
      itemCount: course.videoUrls.length,
      itemBuilder: (context, index) {
        return _buildVideoLessonRow(
          primaryColor,
          index + 1,
          'Video Lesson ${index + 1}',
          course.videoUrls[index],
        );
      },
    );
  }

  Widget _buildVideoLessonRow(
    Color color,
    int number,
    String title,
    String videoUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          onVideoSelect(number - 1);
          // Scroll to top to show video
        },
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: const TextStyle(fontSize: 16))],
              ),
            ),
            Icon(Icons.play_circle_fill, color: color, size: 28),
          ],
        ),
      ),
    );
  }
}
