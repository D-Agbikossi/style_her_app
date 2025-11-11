/**
 * Login Screen - User Authentication
 * 
 * This screen handles user login functionality including:
 * - Email/password authentication
 * - Form validation
 * - Social login buttons (Google, Facebook, Apple)
 * - Navigation to forgot password and sign up screens
 * - Loading states and error handling
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen imports
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/screens/interest_screen.dart';

// Provider imports
import 'package:frontend/providers/auth_provider.dart';

// Theme imports
import '../main.dart';

// Utils imports
import '../utils/validators.dart';

/**
 * LoginScreen - Stateful widget for user authentication
 * Manages login form state, validation, and user interactions
 */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/**
 * Login screen state management
 * Handles form validation, authentication logic, and UI state
 */
class _LoginScreenState extends State<LoginScreen> {
  // Form and UI state
  bool _obscurePassword = true; // Password visibility toggle
  final _formKey = GlobalKey<FormState>(); // Form validation key
  final _emailController = TextEditingController(); // Email input controller
  final _passwordController =
      TextEditingController(); // Password input controller
  bool _isLoading = false; // Loading state for async operations

  /**
   * Clean up controllers when widget is disposed
   * Prevents memory leaks
   */
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /**
   * Handle login form submission
   * Validates form, authenticates user, and navigates to interest screen on success
   */
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const InterestScreen()),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  /**
   * Build the login screen UI
   * Contains form fields, social login buttons, and navigation options
   */
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: isSmallScreen ? 16.0 : 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isSmallScreen ? 40 : 60),
              Center(
                child: Text(
                  "Login",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: kPrimaryText,
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 30 : 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    _buildPasswordField(),
                  ],
                ),
              ),
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
              SizedBox(height: isSmallScreen ? 20 : 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 40),
              const Center(
                child: Text(
                  "Or sign up with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 30),
              _buildSocialButton(
                iconPath: 'assets/google_logo.png',
                label: "Continue with Google",
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                isGoogle: true,
              ),
              SizedBox(height: isSmallScreen ? 12 : 20),
              _buildSocialButton(
                iconPath: 'assets/facebook_logo.png',
                label: "Continue with Facebook",
                backgroundColor: const Color(0xFF1877F2),
                foregroundColor: Colors.white,
              ),
              SizedBox(height: isSmallScreen ? 12 : 20),
              _buildSocialButton(
                iconPath: 'assets/apple_logo.png',
                label: "Continue with Apple",
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              SizedBox(height: isSmallScreen ? 30 : 50),
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
    );
  }

  /**
   * Build email input field with validation
   * Uses validateEmail function from validators utility
   */
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email Address",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          decoration: const InputDecoration(
            hintText: "Input email address",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  /**
   * Build password input field with visibility toggle
   * Uses validatePassword function from validators utility
   */
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: validatePassword,
          decoration: InputDecoration(
            hintText: "Input password",
            border: const OutlineInputBorder(),
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

  /**
   * Build social login button
   * Currently uses placeholder icons - should be replaced with actual social provider assets
   */
  Widget _buildSocialButton({
    required String iconPath,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    bool isGoogle = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    IconData iconData = Icons.error;
    if (label.contains("Google")) iconData = Icons.g_mobiledata;
    if (label.contains("Facebook")) iconData = Icons.facebook;
    if (label.contains("Apple")) iconData = Icons.apple;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(iconData, size: isSmallScreen ? 20 : 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: isGoogle ? 1 : 0,
          side: isGoogle
              ? const BorderSide(color: Colors.black12)
              : BorderSide.none,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
          textStyle: TextStyle(
            fontSize: isSmallScreen ? 14 : 16, 
            fontWeight: FontWeight.w600
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}


