import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/routes.dart';
import '../widgets/profile_picture_widget.dart';
import '../services/mentor_service.dart';

// --- Data Model ---

class Mentor {
  final String id;
  final String name;
  final String specialty;
  final String workplace;
  final int courses;
  final int students;
  final double ratings;
  final String bio;
  final String? photoUrl;

  Mentor({
    required this.id,
    required this.name,
    required this.specialty,
    this.workplace = '',
    this.courses = 0,
    this.students = 0,
    this.ratings = 0.0,
    this.bio = '',
    this.photoUrl,
  });

  factory Mentor.fromMap(Map<String, dynamic> data) {
    return Mentor(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Unknown',
      specialty: data['specialty'] ?? 'General',
      workplace: data['workplace'] ?? '',
      courses: data['videoCount'] ?? 0, // Use videoCount as courses
      students: data['students'] ?? 0,
      ratings: data['ratings'] ?? 0.0,
      bio: data['bio'] ?? '',
      photoUrl: data['photoUrl'],
    );
  }
}

// --- Mentor Card Widget ---

class MentorCard extends StatelessWidget {
  final Mentor mentor;

  const MentorCard({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          leading: ProfilePictureWidget(
            imageUrl: mentor.photoUrl,
            radius: 28,
            backgroundColor: Colors.grey[300]!,
          ),
          title: Text(
            mentor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1E1E1E),
            ),
          ),
          subtitle: Text(
            mentor.specialty,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          onTap: () {
            // NAVIGATION TO PROFILE SCREEN
            Navigator.of(context).pushNamed(
              AppRoutes.mentorProfile,
              arguments: mentor.id, // Pass the mentor ID
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 0.5, color: Color(0xFFE0E0E0)),
        ),
      ],
    );
  }
}

// --- Main Top Mentors Screen Widget ---

class TopMentorsScreen extends StatelessWidget {
  const TopMentorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mentorService = MentorService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Mentors',
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
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: mentorService.getMentorsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading mentors: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No mentors available'),
              );
            }

            final mentors = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Mentor.fromMap({
                'id': doc.id,
                'name': data['displayName'] ?? 'Unknown',
                'specialty': data['specialty'] ?? 'General',
                'workplace': data['workplace'] ?? '',
                'videoCount': data['videoCount'] ?? 0,
                'students': data['students'] ?? 0,
                'ratings': data['ratings'] ?? 0.0,
                'bio': data['bio'] ?? '',
                'photoUrl': data['photoUrl'],
              });
            }).toList();

            return ListView.builder(
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final mentor = mentors[index];
                return MentorCard(mentor: mentor);
              },
            );
          },
        ),
      ),
    );
  }
}
