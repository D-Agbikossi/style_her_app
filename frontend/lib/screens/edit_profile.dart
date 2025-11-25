import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label) => InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      backgroundColor: const Color(0xfff2f4ff),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f4ff),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit Profile",
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
          // ---------------- Avatar Section ----------------
          Center(
            child: Stack(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.image, color: Colors.grey, size: 32),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 4,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          TextField(decoration: deco("Full Name")),
          const SizedBox(height: 14),
          TextField(decoration: deco("Nick Name")),
          const SizedBox(height: 14),
          TextField(decoration: deco("Date of Birth")),
          const SizedBox(height: 14),
          TextField(decoration: deco("Email")),
          const SizedBox(height: 14),

          // ---------------- Phone Field with Flag ----------------
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down, size: 20),
                const SizedBox(width: 8),
                Container(width: 1, height: 25, color: Colors.grey.shade300),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "(+91) 987-848-1225",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ---------------- Gender Dropdown ----------------
          DropdownButtonFormField(
            decoration: deco("Gender"),
            items: const [
              DropdownMenuItem(value: "Male", child: Text("Male")),
              DropdownMenuItem(value: "Female", child: Text("Female")),
            ],
            onChanged: (_) {},
          ),

          const SizedBox(height: 14),
          TextField(decoration: deco("USA")),

          const SizedBox(height: 30),

          // ---------------- Update Button ----------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4A73FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
