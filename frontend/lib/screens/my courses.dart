import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/progress_bar.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    _tab = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: const [Padding(padding: EdgeInsets.only(right:16), child: Icon(Icons.search))],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(28)),
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.text,
              tabs: const [Tab(text: 'Completed'), Tab(text: 'Ongoing')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCourseList(completed:true),
          _buildCourseList(),
        ],
      ),
    );
  }

  Widget _buildCourseCard({required String title, required String category, required String time, required double progress}){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: AppTheme.radius16, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0,4))
      ]),
      child: Row(children: [
        Container(width: 78, height: 58, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(category, style: const TextStyle(color: AppTheme.softText, fontSize: 12)),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(children: const [
            Icon(Icons.star, size: 14, color: Colors.amber),
            SizedBox(width: 2),
            Text('4.6', style: TextStyle(fontSize: 12)),
            SizedBox(width: 8),
            Icon(Icons.schedule, size: 14, color: AppTheme.softText),
            SizedBox(width: 2),
            Text('2 hrs 46 mins', style: TextStyle(fontSize: 12, color: AppTheme.softText)),
          ]),
          const SizedBox(height: 8),
          ProgressBar(progress: progress),
        ])),
      ]),
    );
  }

  Widget _buildCourseList({bool completed=false}){
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCourseCard(title: 'Hair Making Fundamentals', category: 'Hair Making', time: '2h 46m', progress: completed?1:.56),
        _buildCourseCard(title: 'Hair Making Fundamentals', category: 'Hair Making', time: '1h 58m', progress: completed?1:.29),
        _buildCourseCard(title: 'Hair Making Fundamentals', category: 'Hair Making', time: '2h 05m', progress: completed?1:.75),
      ],
    );
  }
}
