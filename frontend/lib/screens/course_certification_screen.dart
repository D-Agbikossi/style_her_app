import 'package:flutter/material.dart';

// --- MAIN APPLICATION WIDGET ---
class CertificateApp extends StatelessWidget {
  const CertificateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificate View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFFF7F8FA,
        ), // Light grey background
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const CertificateScreen(),
    );
  }
}

// --- 1. CERTIFICATE SCREEN (MAIN LAYOUT) ---
class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  // Define the primary blue color used for the design
  final Color primaryColor = const Color(0xFF5C7CEC);

  @override
  Widget build(BuildContext context) {
    // Determine the height of the certificate card as a fraction of screen height
    final double cardHeight = MediaQuery.of(context).size.height * 0.65;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Transparent to blend with the background
        elevation: 0,
        title: const Text('Hair Making 101'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 20,
        ),
        child: Center(
          child: CertificateCard(height: cardHeight, cardColor: primaryColor),
        ),
      ),
      // --- 2. Fixed Bottom Button ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Download Certificate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// --- 3. CERTIFICATE CARD WIDGET ---
class CertificateCard extends StatelessWidget {
  final double height;
  final Color cardColor;

  const CertificateCard({
    super.key,
    required this.height,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Custom Background Shapes (Wavy Blue Background)
          ClipPath(
            clipper: CertificateClipper(),
            child: Container(color: cardColor.withOpacity(0.8)),
          ),

          // Certificate Content
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CertificateContent()),
          ),
        ],
      ),
    );
  }
}

// --- 4. CUSTOM CLIPPER FOR THE WAVY BACKGROUND SHAPE ---
class CertificateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Top-left wave
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.45,
      size.width * 0.4,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.15,
      size.width * 0.8,
      size.height * 0.25,
    );
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width, 0);
    path.close();

    // Bottom-left wave
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.95,
      size.width * 0.6,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.65,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// --- 5. CERTIFICATE TEXT CONTENT ---
class CertificateContent extends StatelessWidget {
  const CertificateContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo (Placeholder)
        const Icon(Icons.style, size: 50, color: Color(0xFF5C7CEC)),
        const Text(
          'STYLIST',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),

        // Title
        const Text(
          'Certificate of Completion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Recipient Text
        const Text(
          'This Certifies that',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),

        // Recipient Name
        const Text(
          'Alex',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF5C7CEC),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Course/Program Text
        const Text(
          'Has Successfully Completed the Wallace Training Program, Entitled.',
          style: TextStyle(fontSize: 14, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Course Name
        const Text(
          'Hair Making 101',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Issued on October 24, 2024\nID: SK24568086',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),

        // Signature
        Container(height: 1, width: 180, color: Colors.black),
        const Text(
          'Denaton Agbikossi', // Signature font is hard to replicate, using a unique one here.
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'GreatVibes', // Placeholder for a script/signature font
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        const Text(
          'Denaton Agbikossi',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'Issued on November 24, 2022',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
