import 'package:flutter/material.dart';

// --- Data Model and Sample Data ---

class Mentor {
  final String name;
  final String specialty;
  // In a real app, this would be a URL or asset path
  // final String imageUrl;

  const Mentor({required this.name, required this.specialty});
}

final List<Mentor> sampleMentors = [
  const Mentor(name: 'Denaton Agbikossi', specialty: 'Hair Making'),
  const Mentor(name: 'Chinemerem Judith', specialty: 'Nail Care'),
  const Mentor(name: 'Precious Mozia', specialty: 'Hair Styling'),
  const Mentor(name: 'Denaton Agbikossi', specialty: 'Hair Making'),
  const Mentor(name: 'Chinemerem Judith', specialty: 'Nail Care'),
  const Mentor(name: 'Precious Mozia', specialty: 'Hair Styling'),
  const Mentor(name: 'Denaton Agbikossi', specialty: 'Hair Making'),
];

// --- Mentor Card Widget ---

class MentorCard extends StatelessWidget {
  final Mentor mentor;

  const MentorCard({Key? key, required this.mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),

          // Left: Circular Mentor Avatar Placeholder
          leading: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.black, // Placeholder for the avatar
              shape: BoxShape.circle,
            ),
            // You would use CircleAvatar with a background image here
          ),

          // Title: Mentor Name
          title: Text(
            mentor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1E1E1E),
            ),
          ),

          // Subtitle: Specialty
          subtitle: Text(
            mentor.specialty,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          onTap: () {
            // Add navigation to mentor profile page here
          },
        ),
        // Subtle divider, as seen in the screenshot's list
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            height: 0.5,
            color: Color(0xFFE0E0E0), // Light gray color for the divider
          ),
        ),
      ],
    );
  }
}

// --- Main Top Mentors Screen Widget ---

class TopMentorsScreen extends StatelessWidget {
  const TopMentorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is set via the theme in main.dart
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
