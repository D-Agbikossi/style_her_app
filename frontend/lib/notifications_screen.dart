import 'package:flutter/material.dart';

// --- Color Helpers & Global Colors (copied from main.dart for self-containment) ---
Color hexToColor(String hexCode) {
  String colorString = 'FF${hexCode.substring(1)}';
  return Color(int.parse(colorString, radix: 16));
}

final Color kPrimaryBlue = hexToColor('#2C5BB1');
final Color kNotificationCardColor = hexToColor('#E8F1FF');

// --- Helper Data Model and Sample Data ---

class NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
  });
}

class NotificationGroup {
  final String title;
  final List<NotificationItem> items;

  const NotificationGroup({required this.title, required this.items});
}

final List<NotificationGroup> sampleData = [
  NotificationGroup(
    title: 'Today',
    items: [
      const NotificationItem(
        title: 'New Category Course.!',
        subtitle: 'New the Hair Making Course is Availa...',
        icon: Icons.apps,
        iconBgColor: Color(0xFFE4ECF8),
      ),
      const NotificationItem(
        title: 'New Category Course.!',
        subtitle: 'New the Hair Styling Course is Availa...',
        icon: Icons.apps,
        iconBgColor: Color(0xFFDCE2F3),
      ),
      const NotificationItem(
        title: 'New Video Uploaded.!',
        subtitle: 'New Video has been uploaded.',
        icon: Icons.play_circle_outline,
        iconBgColor: Color(0xFFE4ECF8),
      ),
    ],
  ),
  NotificationGroup(
    title: 'Yesterday',
    items: [
      const NotificationItem(
        title: 'New Category Course.!',
        subtitle: 'New the Hair Styling Course is Availa...',
        icon: Icons.apps,
        iconBgColor: Color(0xFFE4ECF8),
      ),
    ],
  ),
  NotificationGroup(
    title: 'Nov 20, 2025',
    items: [
      const NotificationItem(
        title: 'Account Setup Successful.!',
        subtitle: 'Your Account has been Created.',
        icon: Icons.person_outline,
        iconBgColor: Color(0xFFE4ECF8),
      ),
    ],
  ),
];

// --- Reusable Notification Card Widget ---

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kNotificationCardColor, // Uses the specified color #E8F1FF
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),

        // Leading Icon Container
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, size: 24, color: kPrimaryBlue),
        ),

        // Notification Title
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF1E1E1E),
          ),
        ),

        // Notification Subtitle
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            item.subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

// --- Main Notifications Screen Widget ---

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView.builder(
          itemCount: sampleData.length,
          itemBuilder: (context, index) {
            final group = sampleData[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    group.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),

                // List of Notification Cards in this group
                ...group.items
                    .map((item) => NotificationCard(item: item))
                    .toList(),

                const SizedBox(height: 12.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
