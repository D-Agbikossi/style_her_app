import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/video_player_widget.dart';
import '../models/course.dart';

class CoursePlayerScreen extends StatefulWidget {
  final String courseId;

  const CoursePlayerScreen({super.key, required this.courseId});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  Course? _course;
  bool _isLoading = true;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCourse();
  }

  Future<void> _fetchCourse() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _course = Course.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(child: Text('Course not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_course!.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Video Player
          Container(
            height: 250,
            color: Colors.black,
            child: _course!.videoUrls.isNotEmpty
                ? VideoPlayerWidget(
                    videoUrl: _course!.videoUrls[_currentVideoIndex],
                    autoPlay: true,
                    showControls: true,
                  )
                : const Center(
                    child: Icon(Icons.videocam_off, color: Colors.white, size: 60),
                  ),
          ),
          
          // Course Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _course!.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _course!.description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          
          // Video List
          if (_course!.videoUrls.length > 1)
            Expanded(
              child: ListView.builder(
                itemCount: _course!.videoUrls.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _currentVideoIndex == index 
                          ? Colors.blue 
                          : Colors.grey,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Video ${index + 1}'),
                    subtitle: const Text('Lesson content'),
                    onTap: () {
                      setState(() {
                        _currentVideoIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}