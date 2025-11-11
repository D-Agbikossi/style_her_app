import 'package:flutter/material.dart';
import '../theme.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0..1
  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 6,
        decoration: BoxDecoration(color: AppTheme.accent.withOpacity(.6)),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0, 1),
          child: Container(color: AppTheme.primary),
        ),
      ),
    );
  }
}