import 'package:flutter/material.dart';
import '../theme_cubit.dart';
import '../widgets/section_item.dart';

class CurriculumDetailScreen extends StatelessWidget {
  final String courseId;
  const CurriculumDetailScreen({Key? key, required this.courseId})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Section 01 - Introduction', '25 Mins'),
          const SectionItem(
            index: 1,
            title: 'Introduction To Hair Mak..',
            duration: '15 Mins',
          ),
          const SectionItem(
            index: 2,
            title: 'Work Station Setup',
            duration: '10 Mins',
          ),
          const SizedBox(height: 12),
          _sectionHeader('Section 02 - How To Braid', '55 Mins'),
          const SectionItem(
            index: 3,
            title: 'How To Braid Like A Pro',
            duration: '08 Mins',
          ),
          const SectionItem(
            index: 4,
            title: 'Braiding Techniques',
            duration: '12 Mins',
          ),
          const SectionItem(
            index: 5,
            title: 'Braiding Techniques',
            duration: '12 Mins',
          ),
          const SectionItem(
            index: 6,
            title: 'How To Braid Like A Pro',
            duration: '12 Mins',
            locked: true,
          ),
          const SizedBox(height: 12),
          _sectionHeader('Section 03 - Let\'s Practice', '35 Mins'),
          const SectionItem(
            index: 7,
            title: 'Let\'s Braid',
            duration: '25 Mins',
            locked: true,
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/video_view'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue Course'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(time, style: const TextStyle(color: AppTheme.softText)),
        ],
      ),
    );
  }
}
