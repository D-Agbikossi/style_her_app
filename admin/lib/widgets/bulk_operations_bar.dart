/**
 * Bulk Operations Bar
 * 
 * Reusable widget for bulk operations (delete, update status, etc.)
 */

import 'package:flutter/material.dart';
import '../main.dart';

class BulkOperationsBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback? onBulkDelete;
  final VoidCallback? onBulkUpdate;
  final String? updateLabel;

  const BulkOperationsBar({
    super.key,
    required this.selectedCount,
    required this.onClearSelection,
    this.onBulkDelete,
    this.onBulkUpdate,
    this.updateLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text(
              '$selectedCount selected',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (onBulkUpdate != null)
              TextButton.icon(
                onPressed: onBulkUpdate,
                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                label: Text(
                  updateLabel ?? 'Update',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            if (onBulkDelete != null)
              TextButton.icon(
                onPressed: onBulkDelete,
                icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            TextButton(
              onPressed: onClearSelection,
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

