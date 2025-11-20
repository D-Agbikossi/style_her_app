import 'package:flutter/material.dart';
import '../theme.dart';
import 'badge_chip.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final String date;
  final List<String> reqs;
  const JobCard({super.key, required this.title, required this.company, required this.location, required this.salary, required this.date, required this.reqs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.radius16,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0,4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(company, style: const TextStyle(color: AppTheme.softText)),
          ])),
          const BadgeChip('Nails'),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.place_outlined, size: 16, color: AppTheme.softText),
          const SizedBox(width: 4),
          Flexible(child: Text(location, style: const TextStyle(color: AppTheme.softText), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          const Icon(Icons.attach_money, size: 16, color: AppTheme.softText),
          const SizedBox(width: 4),
          Flexible(child: Text(salary, style: const TextStyle(color: AppTheme.softText), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          const Icon(Icons.schedule, size: 16, color: AppTheme.softText),
          const SizedBox(width: 4),
          Flexible(child: Text(date, style: const TextStyle(color: AppTheme.softText), overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 12),
        Text('Need mobile nail tech for corporate event. Professional manicures for 20+ attendees.', style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: reqs.map((e) => BadgeChip(e)).toList()),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Apply Now'),
          )),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton(
            onPressed: (){},
            style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: const BorderSide(color: AppTheme.accent), padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Save Job'),
          )),
        ])
      ]),
    );
  }
}
