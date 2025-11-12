import 'package:flutter/material.dart';
import '../theme.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label) => InputDecoration(
      labelText: label,
      filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Stack(children:[
            const CircleAvatar(radius: 42, backgroundColor: AppTheme.accent, child: Icon(Icons.person, size: 42, color: AppTheme.softText)),
            Positioned(right: 0, bottom: 0, child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 18))),
          ])),
          const SizedBox(height: 16),
          TextField(decoration: deco('Full Name')),
          const SizedBox(height: 12),
          TextField(decoration: deco('Nick Name')),
          const SizedBox(height: 12),
          TextField(decoration: deco('Date of Birth')),
          const SizedBox(height: 12),
          TextField(decoration: deco('Email')),
          const SizedBox(height: 12),
          TextField(decoration: deco('Phone')),
          const SizedBox(height: 12),
          DropdownButtonFormField(items: const [DropdownMenuItem(value: 'Female', child: Text('Female')), DropdownMenuItem(value: 'Male', child: Text('Male'))], onChanged: (_) {}, decoration: deco('Gender')),
          const SizedBox(height: 12),
          TextField(decoration: deco('Country')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ()=>Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: const StadiumBorder()),
              child: const Text('Update Profile'),
            ),
          )
        ],
      ),
    );
  }
}
