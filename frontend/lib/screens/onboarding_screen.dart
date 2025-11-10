/**
 * Onboarding Screen - User Introduction
 * 
 * This screen provides a welcome experience for new users including:
 * - Multi-page onboarding flow with PageView
 * - Course discovery introduction
 * - Mentor connection overview
 * - Job opportunity showcase
 * - Smooth page indicator and navigation
 */

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Screen imports
import 'package:frontend/screens/signup_screen.dart';

// Theme imports
import 'package:frontend/main.dart';

/**
 * Onboarding Screen Widget
 * 
 * Main widget for the onboarding flow with page navigation
 */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/**
 * Onboarding Screen State
 * 
 * Manages page controller, current page tracking, and onboarding content
 */
class _OnboardingScreenState extends State<OnboardingScreen> {
  /**
   * Controller for the PageView
   */
  final PageController _controller = PageController();
  
  /**
   * Current page index in the onboarding flow
   */
  int _currentPage = 0;

  /**
   * Onboarding page data with titles and subtitles
   */
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Find a course for You",
      "subtitle": "Begin your journey to beauty mastery",
    },
    {
      "title": "Connect with Mentors",
      "subtitle": "Begin your journey to beauty mastery",
    },
    {
      "title": "Get Job Opportunities", // Corrected spelling
      "subtitle": "Begin your journey to beauty mastery",
    },
  ];

/**
   * Build the onboarding screen UI
   * Includes skip button, PageView, indicator, and navigation button
   */
/**
   * Build the onboarding page UI
   * Shows image placeholder, title, and subtitle
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipToSignUp,
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    title: onboardingData[index]["title"]!,
                    subtitle: onboardingData[index]["subtitle"]!,
                  );
                },
              ),
            ),

            // Dots Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingData.length,
              effect: const WormEffect(
                dotColor: Colors.black12,
                activeDotColor: kPrimaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            const SizedBox(height: 40),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

/**
   * Navigate to next page or sign up screen
   * Handles final page transition to sign up
   */
  void _nextPage() {
    if (_currentPage == onboardingData.length - 1) {
      _skipToSignUp();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  /**
   * Skip onboarding and navigate to sign up screen
   */
  void _skipToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}

/**
 * Onboarding Page Widget
 * 
 * Individual page component for onboarding content
 */
class _OnboardingPage extends StatelessWidget {
  /**
   * Page title text
   */
  final String title;
  
  /**
   * Page subtitle text
   */
  final String subtitle;

  const _OnboardingPage({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- IMAGE PLACEHOLDER ---
        // Replace this Container with your Image.asset
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.image, size: 100, color: Colors.grey[300]),
          ),
        ),
        // --- END PLACEHOLDER ---
        const SizedBox(height: 60),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
