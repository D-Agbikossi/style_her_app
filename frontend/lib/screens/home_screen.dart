/**
 * Home Screen
 * 
 * This screen displays the main dashboard with:
 * - User greeting with profile name
 * - Search functionality for courses
 * - Special offer banner with page indicator
 * - Popular courses section with category filtering
 * - Top mentors section
 * - Real-time course data from provider
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Provider imports
import '../providers/auth_provider.dart';
import '../providers/course_provider.dart';

// Model imports
import '../models/course.dart';

// Theme imports
import '../main.dart';

/**
 * Home Screen
 * 
 * Main widget for the home dashboard
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/**
 * Home Screen State
 * 
 * Manages banner controller, category selection, search functionality
 * and course data loading
 */
class _HomeScreenState extends State<HomeScreen> {
  /**
   * Controller for the special offer banner page view
   */
  final PageController _bannerController = PageController();

  /**
   * Currently selected course category for filtering
   */
  String _selectedCategory = "All";

  /**
   * Available course categories
   */
  final List<String> _categories = ["All", "Make Up", "Hair Styling", "Arts"];

  /**
   * Current search query for course filtering
   */
  String _searchQuery = "";

/**
   * Initialize screen state
   * Loads courses data after widget is built
   */
  @override
  void initState() {
    super.initState();
    // Load courses when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      courseProvider.fetchAllCourses();
      courseProvider.fetchPopularCourses();
    });
  }

/**
   * Build the home screen UI
   * Includes header, search, banner, categories, courses, and mentors
   */
/**
   * Build the course card UI
   * Shows thumbnail, title, category, rating, and module count
   */
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8.0 : 12.0,
            vertical: isSmallScreen ? 4.0 : 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: isSmallScreen ? 2 : 4),
              _buildSearchBar(),
              SizedBox(height: isSmallScreen ? 2 : 4),
              _buildSpecialOfferBanner(),
              SizedBox(height: isSmallScreen ? 2 : 4),
              _buildSectionHeader("Popular Courses"),
              SizedBox(height: isSmallScreen ? 1 : 2),
              _buildCategoryChips(),
              SizedBox(height: isSmallScreen ? 2 : 4),
              _buildPopularCoursesList(),
              SizedBox(height: isSmallScreen ? 4 : 8),
              _buildSectionHeader("Top Mentor"),
              SizedBox(height: isSmallScreen ? 2 : 4),
              _buildTopMentorList(),
              SizedBox(height: isSmallScreen ? 4 : 8),
            ],
          ),
        ),
      ),
    );
  }

/**
   * Build the header section with user greeting and notification icon
   */
  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context);
    final fullName = authProvider.profile?.displayName ?? 'User';
    final firstName = fullName.split(' ').first;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 12 : 16, 
        isSmallScreen ? 8 : 12, 
        isSmallScreen ? 12 : 16, 
        isSmallScreen ? 4 : 8
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $firstName",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A6FDB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "What would you like to learn Today?",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.logout, size: 20),
                color: Colors.grey[700],
                onPressed: () async {
                  await authProvider.signOut();
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, size: 24),
                color: Colors.grey[700],
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

/**
   * Build the search bar for course filtering
   */
  Widget _buildSearchBar() {
    final courseProvider = Provider.of<CourseProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16, 
        vertical: isSmallScreen ? 4 : 8
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Search Courses",
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

/**
   * Build the special offer banner with discount information
   */
  Widget _buildSpecialOfferBanner() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Container(
        height: isSmallScreen ? 140 : 160,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "25% OFF",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Today's Special",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Get a Discount for Every Course\nOrder only Valid for Today.!",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.brush, size: 80, color: Colors.white24),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SmoothPageIndicator(
                  controller: _bannerController,
                  count: 4,
                  effect: const ScrollingDotsEffect(
                    dotColor: Colors.white38,
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

/**
   * Build a section header with title and "SEE ALL" button
   * 
   * @param title The section title
   */
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "SEE ALL",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

/**
   * Build category filter chips for course filtering
   */
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey[100],
              selectedColor: kPrimaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
              shape: StadiumBorder(),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

/**
   * Build the popular courses horizontal list
   * Shows loading state, empty state, or course cards
   */
  Widget _buildPopularCoursesList() {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.popularCourses;
    
    if (courseProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (courses.isEmpty) {
      return const Center(
        child: Text('No courses available'),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return SizedBox(
      height: isSmallScreen ? 220 : 250,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _CourseCard(
              title: course.title,
              category: course.category,
              rating: course.rating,
              modules: course.lessonCount,
              level: course.difficulty,
              price: course.isFree ? null : course.price,
              thumbnailUrl: course.thumbnailUrl,
            ),
          );
        },
      ),
    );
  }

/**
   * Build the top mentors horizontal list
   * Shows mentor avatars and names
   */
  Widget _buildTopMentorList() {
    final List<String> mentors = ["Precious", "Brunelle", "Judith", "Jane"];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[800], // Image Placeholder
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  mentors[index],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/**
 * Course Card Widget
 * 
 * Reusable card component for displaying course information
 */
class _CourseCard extends StatelessWidget {
  /**
   * Course title
   */
  final String title, category, level;
  
  /**
   * Course rating
   */
  final double rating;
  
  /**
   * Number of modules in the course
   */
  final int modules;
  
  /**
   * Course price (null if free)
   */
  final double? price;
  
  /**
   * Course thumbnail image URL
   */
  final String? thumbnailUrl;
  
  const _CourseCard({
    required this.title,
    required this.category,
    required this.level,
    required this.rating,
    required this.modules,
    this.price,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 5, 
        vertical: isSmallScreen ? 8 : 10
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isSmallScreen ? 100 : 120,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              image: thumbnailUrl != null
                  ? DecorationImage(
                      image: NetworkImage(thumbnailUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: thumbnailUrl == null
                ? Center(
                    child: Icon(Icons.videocam, color: Colors.white30, size: 50),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(Icons.bookmark_border, color: kPrimaryColor),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(level, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "$rating",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "| $modules Modules",
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
