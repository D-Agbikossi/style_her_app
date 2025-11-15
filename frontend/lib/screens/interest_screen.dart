/**
 * Interest Selection Screen
 * 
 * This screen allows users to select their interests:
 * - Display available interest categories
 * - Multi-select interest chips
 * - Navigation to home screen
 * - Skip option for users who don't want to select interests
 */

import 'package:flutter/material.dart';

// Screen imports
import 'package:frontend/routes.dart';

// Theme imports
import '../main.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1); // Main brand blue
const Color kBackgroundColor = Color(0xFFF5F9FF); // App background color

/**
 * Interest Selection Screen
 * 
 * Main widget for interest selection functionality
 */
class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

/**
 * Interest Selection Screen State
 * 
 * Manages available interests and user selections
 */
class _InterestScreenState extends State<InterestScreen> {
  /**
   * Available interest categories for users to select from
   * Covers various beauty and personal care topics
   */
  final List<String> _interests = [
    "Show All",
    "Make Up",
    "Hair Making",
    "Soap Making",
    "Hair Styling",
    "Nail Care",
    "Face oils",
    "Skincare",
    "Suncare",
    "Tools",
  ];

  /**
   * Set of currently selected interests
   * Uses Set for efficient add/remove operations
   */
  final Set<String> _selectedInterests = {};

  /**
   * Build the interest selection screen UI
   * Includes title, subtitle, interest chips, and navigation buttons
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Title
              Text(
                "Choose your favorite interest",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You can choose more than one",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    alignment: WrapAlignment.center,
                    children: _interests.map((interest) {
                      final bool isSelected = _selectedInterests.contains(
                        interest,
                      );
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedInterests.add(interest);
                            } else {
                              _selectedInterests.remove(interest);
                            }
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: kPrimaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? kPrimaryColor
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToHome,
                  child: const Text("Next"),
                ),
              ),
              TextButton(
                onPressed: _navigateToHome,
                child: const Text(
                  "Skip for now",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Navigate to home screen
   * Used for both Next and Skip actions
   * Replaces current route to prevent back navigation
   */
  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}
