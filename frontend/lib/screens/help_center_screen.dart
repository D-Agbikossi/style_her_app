/**
 * Help Center Screen
 * 
 * This screen provides help and support information including:
 * - Frequently asked questions (FAQ)
 * - Contact support
 * - Help articles
 * - Troubleshooting guides
 */

import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1);
const Color kBackgroundColor = Color(0xFFF5F9FF);

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I enroll in a course?',
      answer:
          'To enroll in a course, simply browse to the course detail page and click the "Enroll Now" button. For free courses, enrollment is instant. For paid courses, you\'ll need to complete the payment process first.',
    ),
    FAQItem(
      question: 'Can I access courses offline?',
      answer:
          'Yes! You can download courses for offline viewing. Go to "My Courses" and tap the download icon next to any enrolled course. Downloaded courses can be accessed without an internet connection.',
    ),
    FAQItem(
      question: 'How do I reset my password?',
      answer:
          'If you\'ve forgotten your password, go to the login screen and tap "Forgot Password?". Enter your email address and you\'ll receive instructions to reset your password.',
    ),
    FAQItem(
      question: 'How do I contact a mentor?',
      answer:
          'You can contact mentors through the Inbox feature. Navigate to the mentor\'s profile and tap the "Message" button, or go to Inbox and start a new conversation.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept credit/debit cards, mobile money (MTN, Airtel, Orange Money), and PayPal. You can manage your payment methods in the Payment section of your profile.',
    ),
    FAQItem(
      question: 'Can I get a refund?',
      answer:
          'Yes, we offer refunds within 30 days of purchase if you\'re not satisfied with a course. Contact our support team through the Help Center to request a refund.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for help...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          _buildSectionHeader('Quick Actions'),
          const SizedBox(height: 12),
          _buildActionCard(
            icon: Icons.support_agent,
            title: 'Contact Support',
            subtitle: 'Get help from our support team',
            onTap: () {
              _showContactSupportDialog();
            },
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Chat with us in real-time',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Live chat coming soon')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'support@styleher.com',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email support: support@styleher.com')),
              );
            },
          ),

          const SizedBox(height: 32),

          // FAQ Section
          _buildSectionHeader('Frequently Asked Questions'),
          const SizedBox(height: 12),
          ..._faqs.map((faq) => _buildFAQCard(faq)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kPrimaryColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq.answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
        iconColor: kPrimaryColor,
        collapsedIconColor: Colors.grey,
      ),
    );
  }

  void _showContactSupportDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support request submitted. We\'ll get back to you soon!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}


