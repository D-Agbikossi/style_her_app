/**
 * Onboarding Screen - User Introduction
 * * This screen provides a welcome experience for new users including:
 * - Multi-page onboarding flow with PageView
 * - Course discovery introduction
 * - Mentor connection overview
 * - Job opportunity showcase
 * - Smooth page indicator and navigation
 */

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Screen imports
import 'package:frontend/routes.dart';

// Theme imports
import 'package:frontend/main.dart';

// I updated this primary color to match the button in your screenshot exactly
const Color kPrimaryColor = Color(0xFF7292CF);
const Color kTitleColor = Color(0xFF6B86C2); // Blue for title
const Color kSubtitleColor = Color(0xFF9FAFD6); // Lighter blue for subtitle

/**
 * Onboarding Screen Widget
 * * Main widget for the onboarding flow with page navigation
 */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/**
 * Onboarding Screen State
 * * Manages page controller, current page tracking, and onboarding content
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
      "title": "Get Job Opportunities",
      "subtitle": "Begin your journey to beauty mastery",
    },
  ];

  /**
   * Build the onboarding screen UI
   * Includes skip button, PageView, indicator, and navigation button
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure background is white
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
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
                dotColor: Color(0xFFE0E0E0), // Light grey for inactive
                activeDotColor: kPrimaryColor, // Blue for active
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
            const SizedBox(height: 40),

            // Next Button - UPDATED to match screenshot
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55, // Fixed height for a solid look
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor, // The blue from the image
                    foregroundColor: Colors.white, // Text color
                    elevation: 0, // Flat look
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners (not pill)
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
    Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
  }
}

/**
 * Onboarding Page Widget
 * * Individual page component for onboarding content
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
        Image.asset(
          'assets/style_her.png',
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 40),
        // UPDATED Title Styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kTitleColor, // Custom Blue Color
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        // UPDATED Subtitle Styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: kSubtitleColor, // Lighter Blue/Purple Color
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
