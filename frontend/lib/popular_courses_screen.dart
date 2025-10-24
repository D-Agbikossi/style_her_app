import 'package:flutter/material.dart';

// --- Color Helpers ---
Color hexToColor(String hexCode) {
  String colorString = 'FF${hexCode.substring(1)}';
  return Color(int.parse(colorString, radix: 16));
}

// Global colors defined in main.dart (copied for self-containment)
final Color kBackgroundColor = hexToColor('#F5F9FF');
final Color kPrimaryBlue = hexToColor(
  '#2C5BB1',
); // Used for active buttons/icons
final Color kCourseCardColor =
    Colors.white; // Course cards appear white in the image

// --- Data Models and Sample Data ---

class Course {
  final String category;
  final String title;
  final String price;
  final double rating;
  final int modules;

  const Course({
    required this.category,
    required this.title,
    required this.price,
    required this.rating,
    required this.modules,
  });
}

final List<String> categories = [
  'All',
  'Hair Styling',
  'Hair Making',
  'Arts',
  'Make Up',
  'Nail Care',
];

final List<Course> sampleCourses = [
  const Course(
    category: 'Hair Making',
    title: 'Fundamentals of Hair Making',
    price: '7058/-',
    rating: 4.2,
    modules: 8,
  ),
  const Course(
    category: 'Hair Styling',
    title: 'Hair Styling 101',
    price: r'$20', // Use r'$' for raw string if price is dollars
    rating: 3.9,
    modules: 12,
  ),
  const Course(
    category: 'Make Up',
    title: 'Introduction to Make Up',
    price: r'$20',
    rating: 4.2,
    modules: 9,
  ),
  const Course(
    category: 'Nail Care',
    title: 'Acrylic Nails Tutorial',
    price: r'$25',
    rating: 4.9,
    modules: 10,
  ),
  const Course(
    category: 'Hair Styling',
    title: 'Hair Styling Tricks',
    price: r'$67',
    rating: 4.5, // Assumed rating
    modules: 6, // Assumed modules
  ),
];

// --- Course Card Widget ---

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: kCourseCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Placeholder for the Course Image/Thumbnail
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black, // Placeholder black color
                borderRadius: BorderRadius.circular(8),
              ),
              // You would add an Image.network or Image.asset here
            ),
            const SizedBox(width: 12),

            // Right: Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Category & Bookmark Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons.bookmark_border,
                        color: kPrimaryBlue,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Row 2: Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Row 3: Price
                  Text(
                    course.price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBlue,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Row 4: Rating & Modules
                  Row(
                    children: [
                      // Rating Star and Value
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Separator
                      Container(width: 1, height: 16, color: Colors.grey[300]),

                      const SizedBox(width: 12),

                      // Modules Count
                      Text(
                        '${course.modules} Modules',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Category Chip Widget ---

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimaryBlue : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Main Popular Courses Screen Widget (Stateful for category selection) ---

class PopularCoursesScreen extends StatefulWidget {
  const PopularCoursesScreen({Key? key}) : super(key: key);

  @override
  State<PopularCoursesScreen> createState() => _PopularCoursesScreenState();
}

class _PopularCoursesScreenState extends State<PopularCoursesScreen> {
  // 'All' is selected by default
  String _selectedCategory = categories.first;

  // Filters the course list based on the selected category
  List<Course> get _filteredCourses {
    if (_selectedCategory == 'All') {
      return sampleCourses;
    }
    return sampleCourses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Popular Courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Category Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: categories.map((category) {
                  return CategoryChip(
                    category: category,
                    isSelected: category == _selectedCategory,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // 2. Course List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final course = _filteredCourses[index];
                return CourseCard(course: course);
              },
            ),
          ),
        ],
      ),
    );
  }
}
