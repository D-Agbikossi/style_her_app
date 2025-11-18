/**
 * Admin Dashboard Screen
 * 
 * This screen displays the main admin dashboard with:
 * - Real-time statistics (users, mentors, courses)
 * - Quick action buttons (Add Video, Add Mentor, Manage Categories)
 * - Recent uploads list
 * - Bottom navigation bar for accessing other admin screens
 * - Logout functionality
 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Route imports
import '../routes.dart';

// Provider imports
import '../providers/admin_auth_provider.dart';

// Service imports
import '../services/admin_service.dart';

// Theme imports
import '../main.dart';

/**
 * AdminDashboardScreen - Stateful widget for admin dashboard
 * Main widget for the admin dashboard with statistics and quick actions
 */
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

/**
 * Admin dashboard screen state management
 * Manages statistics loading, navigation, and UI state
 */
class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Navigation state
  int _selectedIndex = 0; // Currently selected bottom navigation index
  
  // Statistics data
  int _totalUsers = 0; // Total number of users
  int _totalMentors = 0; // Total number of mentors
  int _totalVideos = 0; // Total number of courses/videos
  
  // Service instance
  final _adminService = AdminService();

  /**
   * Initialize screen state
   * Loads statistics data after widget is built
   */
  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  /**
   * Load statistics from Firebase
   * Fetches counts for users, mentors, and courses
   */
  Future<void> _loadStats() async {
    try {
      final stats = await _adminService.getStats();
      setState(() {
        _totalUsers = stats['users'] ?? 0;
        _totalMentors = stats['mentors'] ?? 0;
        _totalVideos = stats['courses'] ?? 0;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  /**
   * Handle bottom navigation item tap
   * Navigates to corresponding screen based on selected index
   */
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, AdminRoutes.mentors).then((_) => _loadStats());
        break;
      case 2:
        Navigator.pushNamed(context, AdminRoutes.videos).then((_) => _loadStats());
        break;
      case 3:
        Navigator.pushNamed(context, AdminRoutes.users).then((_) => _loadStats());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Provider.of<AdminAuthProvider>(context).user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await Provider.of<AdminAuthProvider>(context, listen: false).signOut();
                    },
                  ),
                ],
              ),
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Users',
                      value: _totalUsers.toString(),
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Total Mentors',
                      value: _totalMentors.toString(),
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Total Videos',
                      value: _totalVideos.toString(),
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _ActionButton(
                    icon: Icons.add_circle,
                    label: 'Add Video',
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, AdminRoutes.addCourse);
                      if (result == true) {
                        _loadStats();
                      }
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.person_add,
                    label: 'Add Mentor',
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, AdminRoutes.addMentor);
                      if (result == true) {
                        _loadStats();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.category,
                    label: 'Manage Categories',
                    onTap: () {
                      Navigator.pushNamed(context, AdminRoutes.management);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Uploads
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Uploads',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .orderBy('createdAt', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No recent uploads'),
                    );
                  }

                  final docs = snapshot.data!.docs.take(5).toList();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      DateTime date = DateTime.now();
                      if (data['createdAt'] != null) {
                        if (data['createdAt'] is Timestamp) {
                          date = (data['createdAt'] as Timestamp).toDate();
                        } else if (data['createdAt'] is DateTime) {
                          date = data['createdAt'] as DateTime;
                        }
                      }
                      return _RecentUploadCard(
                        title: data['title'] ?? 'Untitled',
                        instructor: data['instructor'] ?? 'Unknown',
                        date: date,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Mentors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? kPrimaryColor : kPrimaryColor.withOpacity(0.1),
          foregroundColor: isPrimary ? Colors.white : kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _RecentUploadCard extends StatelessWidget {
  final String title;
  final String instructor;
  final DateTime date;

  const _RecentUploadCard({
    required this.title,
    required this.instructor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final daysAgo = DateTime.now().difference(date).inDays;
    final dateText = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
            ? 'Yesterday'
            : '$daysAgo days ago';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: kPrimaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'By $instructor • $dateText',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
