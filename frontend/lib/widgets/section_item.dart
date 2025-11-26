import 'package:flutter/material.dart';
import '../theme_cubit.dart';

class SectionItem extends StatelessWidget {
  final int index;
  final String title;
  final String duration;
  final bool locked;
  const SectionItem({
    super.key,
    required this.index,
    required this.title,
    required this.duration,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.radius12,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.accent,
            child: Text(
              index.toString(),
              style: const TextStyle(color: AppTheme.text),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    color: AppTheme.softText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            locked ? Icons.lock_outline : Icons.play_circle_fill,
            color: locked ? AppTheme.softText : AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
