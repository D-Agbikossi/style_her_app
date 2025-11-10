import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Make Up", "Hair Styling", "Arts"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildSpecialOfferBanner(),
              _buildSectionHeader("Popular Courses"), // Corrected spelling
              _buildCategoryChips(),
              _buildPopularCoursesList(),
              _buildSectionHeader("Top Mentor"),
              _buildTopMentorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, ALEX",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6FDB),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "What would you like to learn Today?",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 30),
            color: Colors.grey[700],
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
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

  Widget _buildSpecialOfferBanner() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 160,
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

  Widget _buildPopularCoursesList() {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: const [
          _CourseCard(
            title: "Introduction To Make Up",
            category: "Make Up",
            rating: 4.2,
            modules: 8,
            level: "Beginner",
          ),
          _CourseCard(
            title: "Advanced Hair Styling",
            category: "Hair Styling",
            rating: 4.8,
            modules: 12,
            level: "Advanced",
            price: 400,
          ),
          _CourseCard(
            title: "Advanced Hair Styling",
            category: "Hair Styling",
            rating: 4.8,
            modules: 12,
            level: "Advanced",
            price: 400,
          ),
          _CourseCard(
            title: "Advanced Hair Styling",
            category: "Hair Styling",
            rating: 4.8,
            modules: 12,
            level: "Advanced",
            price: 400,
          ),
        ],
      ),
    );
  }

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

class _CourseCard extends StatelessWidget {
  final String title, category, level;
  final double rating;
  final int modules;
  final double? price;
  const _CourseCard({
    required this.title,
    required this.category,
    required this.level,
    required this.rating,
    required this.modules,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(Icons.videocam, color: Colors.white30, size: 50),
            ),
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
