import 'package:flutter/material.dart';
import 'package:frontend/routes.dart'; // Ensure routes are imported

// --- Data Model and Sample Data ---

class Mentor {
  // ADD ID AND PROFILE DETAILS
  final String id;
  final String name;
  final String specialty;
  final String workplace;
  final int courses;
  final int students;
  final double ratings;
  final String bio;

  const Mentor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.workplace,
    required this.courses,
    required this.students,
    required this.ratings,
    required this.bio,
  });
}

// UPDATED SAMPLE DATA
final List<Mentor> sampleMentors = [
  const Mentor(
    id: 'M001',
    name: 'Denaton Agbikossi',
    specialty: 'Hair Making',
    workplace: 'Maison de Joelle',
    courses: 12,
    students: 158,
    ratings: 500,
    bio:
        "Hair Making is what I do for a living and I absolutely love doing it and also teaching about it!",
  ),
  const Mentor(
    id: 'M002',
    name: 'Chinemerem Judith',
    specialty: 'Nail Care',
    workplace: 'Luxury Spa',
    courses: 8,
    students: 90,
    ratings: 230,
    bio:
        "Passionate about artistic nail design and giving my students the best foundation in the industry.",
  ),
  const Mentor(
    id: 'M003',
    name: 'Precious Mozia',
    specialty: 'Hair Styling',
    workplace: 'StyleHer Academy',
    courses: 20,
    students: 300,
    ratings: 750,
    bio:
        "My goal is to empower the next generation of stylists with modern techniques and business skills.",
  ),
  const Mentor(
    id: 'M004',
    name: 'Jane Doe',
    specialty: 'Skin Care',
    workplace: 'Dermatology Center',
    courses: 5,
    students: 50,
    ratings: 150,
    bio: "Focused on holistic skin health and science-backed routines.",
  ),
];

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
          leading: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.black, // Placeholder for the avatar
              shape: BoxShape.circle,
            ),
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
        child: ListView.builder(
          itemCount: sampleMentors.length,
          itemBuilder: (context, index) {
            final mentor = sampleMentors[index];
            return MentorCard(mentor: mentor);
          },
        ),
      ),
    );
  }
}
