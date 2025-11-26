/**
 * Interest Selection Screen
 * * This screen allows users to select their interests:
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

// Import for navigation
import 'bottom_navigation_screen.dart';

const Color kButtonBlue = Color(0xFF6B86D4);

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
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

  final Set<String> _selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You can choose more than one",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Chips Section
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
                        selectedColor: kButtonBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? kButtonBlue : Colors.grey[300]!,
                            width: 1.0,
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
                height: 56,
                child: ElevatedButton(
                  onPressed: _navigateToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text("Next"),
                ),
              ),

              const SizedBox(height: 16),

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

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }
}
