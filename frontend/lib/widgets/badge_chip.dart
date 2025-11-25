import 'package:flutter/material.dart';
import '../theme_cubit.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  const BadgeChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppTheme.text),
      ),
    );
  }
}
