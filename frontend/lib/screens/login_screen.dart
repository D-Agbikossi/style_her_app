import 'package:flutter/material.dart';
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/screens/interest_screen.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 50),
                _buildTextField("Email Address", "Input email address"),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Interest screen on successful login
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const InterestScreen(),
                        ), // <-- UPDATED THIS LINE
                      );
                    },
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Or sign up with",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                _buildSocialButton(
                  iconPath: 'assets/google_logo.png', // <-- ADD YOUR ASSET
                  label: "Continue with Google",
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  isGoogle: true,
                ),
                const SizedBox(height: 20),
                _buildSocialButton(
                  iconPath: 'assets/facebook_logo.png', // <-- ADD YOUR ASSET
                  label: "Continue with Facebook",
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                _buildSocialButton(
                  iconPath: 'assets/apple_logo.png', // <-- ADD YOUR ASSET
                  label: "Continue with Apple",
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Re-using the same helper widgets from SignUp screen
  // In a real app, these would be in a separate 'widgets' file.

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(decoration: InputDecoration(hintText: hint)),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Input password",
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isGoogle = false,
  }) {
    IconData iconData = Icons.error;
    if (label.contains("Google")) iconData = Icons.g_mobiledata;
    if (label.contains("Facebook")) iconData = Icons.facebook;
    if (label.contains("Apple")) iconData = Icons.apple;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          iconData,
        ), // <-- REPLACE with Image.asset(iconPath, height: 24)
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: isGoogle ? 1 : 0,
          side: isGoogle
              ? const BorderSide(color: Colors.black12)
              : BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () {},
      ),
    );
  }
}
