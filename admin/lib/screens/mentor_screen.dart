/**
 * Mentor Management Screen
 * 
 * This screen handles mentor management functionality including:
 * - Display all mentors with real-time updates
 * - Search and filter mentors by status
 * - Create, edit, and delete mentors
 * - Real-time data synchronization with Firestore
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/admin_service.dart';
import '../routes.dart';
import '../main.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _adminService = AdminService();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteMentor(String mentorId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Mentor?'),
        content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.deleteMentor(mentorId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mentor deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showMentorOptions(Map<String, dynamic> mentor) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Mentor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AdminRoutes.editMentor,
                  arguments: mentor,
                ).then((result) {
                  if (result == true) {
                    setState(() {}); // Refresh
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Mentor', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMentor(mentor['id'], mentor['displayName'] ?? 'Unknown');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: const Text(
          'Manage Mentors',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: kPrimaryColor, size: 32),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, AdminRoutes.addMentor);
              if (result == true) {
                setState(() {}); // Refresh
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == 'All',
                    onTap: () => setState(() => _selectedFilter = 'All'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    isSelected: _selectedFilter == 'Active',
                    onTap: () => setState(() => _selectedFilter = 'Active'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Suspended',
                    isSelected: _selectedFilter == 'Suspended',
                    onTap: () => setState(() => _selectedFilter = 'Suspended'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mentor List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _adminService.getMentorsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No mentors found'));
                }

                final mentors = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['displayName']?.toString().toLowerCase() ?? '';
                  if (_searchController.text.isNotEmpty) {
                    if (!name.contains(_searchController.text.toLowerCase())) {
                      return false;
                    }
                  }
                  final status = data['status'] ?? 'active';
                  if (_selectedFilter == 'All') return true;
                  if (_selectedFilter == 'Active' && status == 'active') return true;
                  if (_selectedFilter == 'Suspended' && status == 'suspended') return true;
                  return false;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: mentors.length,
                  itemBuilder: (context, index) {
                    final doc = mentors[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _MentorCard(
                      id: doc.id,
                      name: data['displayName'] ?? 'Unknown',
                      specialty: data['specialty'] ?? 'General',
                      status: data['status'] ?? 'active',
                      videoCount: data['videoCount'] ?? 0,
                      mentorData: {'id': doc.id, ...data},
                      onOptionsTap: () => _showMentorOptions({'id': doc.id, ...data}),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _MentorCard extends StatelessWidget {
  final String id;
  final String name;
  final String specialty;
  final String status;
  final int videoCount;
  final Map<String, dynamic> mentorData;
  final VoidCallback onOptionsTap;

  const _MentorCard({
    required this.id,
    required this.name,
    required this.specialty,
    required this.status,
    required this.videoCount,
    required this.mentorData,
    required this.onOptionsTap,
  });

  Widget _buildProfilePicture({String? photoUrl, required double radius}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.grey[600],
                ),
              )
            : Icon(
                Icons.person,
                size: radius,
                color: Colors.grey[600],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfilePicture(
                photoUrl: mentorData['photoUrl'],
                radius: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: onOptionsTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Active' : 'Suspended',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$videoCount Videos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
