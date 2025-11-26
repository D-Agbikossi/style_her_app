import 'package:flutter/material.dart';

// ======================================================
// COURSE COMPLETED CARD — FINAL VERSION (200px ICON + CONFETTI FIXED)
// ======================================================

class CourseCompletedCard extends StatelessWidget {
  const CourseCompletedCard({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonBlue = Color(0xFF5A7DFF);

    return Center(
      child: Container(
        width: 330,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 25,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ======================================================
            // CONFETTI + ICON (UPDATED TO MATCH UI EXACTLY)
            // ======================================================
            SizedBox(
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // ⭐ Yellow star — lowered
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Icon(Icons.star, size: 18, color: Color(0xFFFFC727)),
                  ),

                  // — Blue slash — lowered
                  Positioned(
                    top: 50,
                    left: 110,
                    child: _slash(
                      const Color.fromARGB(255, 11, 53, 131),
                      width: 34,
                      angle: -5.2,   // EXACT angle from screenshot
                    ),
                  ),
                  // — Green slash — lowered
                  Positioned(
                    top: 58,
                    left: 130,
                    child: _slash(
                      const Color(0xFF3ECC6F),
                      width: 34,
                      angle: -5.2,   // EXACT angle from screenshot
                    ),
                  ),
                  // • Orange dot — lowered
                  Positioned(
                    top: 70,
                    left: 95,
                    child: _dot(12, Color(0xFFFFA41B)),
                  ),

                  // • Brown dot — lowered
                  Positioned(
                    top: 80,
                    right: 70,
                    bottom: 75,
                    child: _dot(12, Color(0xFF7B4F3A)),
                  ),

                  // ⭐ Red star — left mid
                  Positioned(
                    top: 125,
                    left: 50,
                    child: Icon(Icons.star, size: 16, color: Color(0xFFFF4A4A)),
                  ),

                  // • Teal dot — mid-left
                  Positioned(
                    top: 150,
                    left: 60,
                    bottom: 20,
                    child: _dot(10, Color(0xFF03DAC6)),
                  ),

                  // ▲ Green triangle — mid-right
                  Positioned(
                    top: 150,
                    right: 20,
                    child: _triangle(16, Color(0xFF2EAF59)),
                  ),

                  // ▲ Blue triangle — bottom-left
                  Positioned(
                    top: 250,
                    left: 50,
                    bottom: -5,
                    child: _triangle(18, Color.fromARGB(255, 27, 16, 70)),
                  ),

                  // 🎧 200px headset icon
                  Positioned(
                    top: 90,
                    child: Image.asset(
                      "assets/grad_headset.png",
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ======================================================
            // TITLE
            // ======================================================
            const Text(
              "Course Completed",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 33, 20, 73),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Complete your Course. Please Write a Review",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 80, 89, 106),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // STAR RATING (FINAL FIXED VERSION)
            // ======================================================
            AnimatedStarRating(
              initialRating: 4,
              onRatingSelected: (_) {},
            ),

            const SizedBox(height: 28),

            // ======================================================
            // BUTTON
            // ======================================================
            reviewButton(buttonBlue),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // CONFETTI HELPERS
  // ------------------------------------------------------

  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _slash(Color color, {double width = 26, double angle = -0.2}) {
  return Transform.rotate(
    angle: angle,
    child: Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}


  Widget _triangle(double size, Color color) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrianglePainter(color),
    );
  }
}

// Draw triangle shapes
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final p = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ======================================================
// ⭐ FINAL STAR RATING — ERROR-PROOF VERSION
// ======================================================

class AnimatedStarRating extends StatefulWidget {
  final int initialRating;
  final Function(int rating) onRatingSelected;

  const AnimatedStarRating({
    super.key,
    this.initialRating = 0,
    required this.onRatingSelected,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with TickerProviderStateMixin {
  int rating = 0;

  late List<AnimationController> controllers;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;

    controllers = List.generate(
      5,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 130),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          bool active = i < rating;

          return GestureDetector(
            onTap: () {
              setState(() => rating = i + 1);
              controllers[i].forward(from: 0.0).then((_) => controllers[i].reverse());
              widget.onRatingSelected(rating);
            },
            child: SizedBox(
              width: 35,
              height: 35,
              child: AnimatedBuilder(
                animation: controllers[i],
                builder: (_, child) {
                  final scale = 1.0 + controllers[i].value * 0.18;  
                  return Transform.scale(scale: scale, child: child);
                },
                child: Icon(
                  Icons.star,
                  size: 24,
                  color: active ? const Color(0xFFFFA41B) : Colors.grey.shade400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ======================================================
// BLUE BUTTON
// ======================================================

Widget reviewButton(Color blue) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: blue,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const SizedBox(width: 24),
        const Text(
          "Write a Review",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: blue,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}
