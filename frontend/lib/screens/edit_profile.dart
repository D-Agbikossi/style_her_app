import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/blocs/auth_bloc.dart';
import '../widgets/profile_picture_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthBloc>(context, listen: false);
    final user = authProvider.user;
    final profile = authProvider.profile;

    _nameController = TextEditingController(
      text: profile?.name ?? user?.displayName ?? "",
    );
    _nicknameController = TextEditingController(text: profile?.nickname ?? "");
    _dobController = TextEditingController(text: profile?.dob ?? "");
    _emailController = TextEditingController(
      text: profile?.email ?? user?.email ?? "",
    );
    _locationController = TextEditingController(text: "USA");

    _selectedGender = profile?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4A73FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<AuthBloc>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          final profile = authProvider.profile;
          final photoUrl = profile?.photoUrl ?? user?.photoURL;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Stack(
                  children: [
                    ProfilePictureWidget(
                      imageUrl: photoUrl,
                      radius: 47.5,
                      backgroundColor: Colors.white,
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderWidth: 3,
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
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: _nameController,
                decoration: deco("Full Name"),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _nicknameController,
                decoration: deco("Nick Name"),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _dobController,
                readOnly: true,
                decoration: deco("Date of Birth").copyWith(
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ),
                ),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                decoration: deco("Email"),
              ),
              const SizedBox(height: 14),

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
                    Container(
                      width: 1,
                      height: 25,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "(+91) 987-848-1225",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                decoration: deco("Gender"),
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 14),
              TextField(
                controller: _locationController,
                decoration: deco("USA"),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await authProvider.updateUserProfile(
                        name: _nameController.text,
                        nickname: _nicknameController.text,
                        dob: _dobController.text,
                        gender: _selectedGender ?? "Not Specified",
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully"),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    }
                  },
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
          );
        },
      ),
    );
  }
}
