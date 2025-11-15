/**
 * Sign Up Screen - User Registration
 * 
 * This screen handles user registration functionality including:
 * - Full name, email, country input
 * - Password creation with validation
 * - Form validation
 * - Social sign up buttons (Google, Facebook, Apple)
 * - Navigation to login screen
 * - Loading states and error handling
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen imports
import 'package:frontend/screens/login_screen.dart';

// Provider imports
import 'package:frontend/providers/auth_provider.dart';

// Services imports
import '../services/google_auth_service.dart';

// Theme imports
import '../main.dart';

// Utils imports
import '../utils/validators.dart';

const Color kPrimaryColor = Color(0xFF2C5BB1); // Main brand blue
const Color kBackgroundColor = Color(0xFFF5F9FF); // App background color

/**
 * SignUpScreen - Stateful widget for user registration
 * Manages registration form state, validation, and user interactions
 */
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

/**
 * Sign up screen state management
 * Handles form validation, user registration logic, and UI state
 */
class _SignUpScreenState extends State<SignUpScreen> {
  // Form and UI state
  bool _obscurePassword = true; // Password visibility toggle
  final _formKey = GlobalKey<FormState>(); // Form validation key
  final _nameController = TextEditingController(); // Name input controller
  final _emailController = TextEditingController(); // Email input controller
  final _passwordController = TextEditingController(); // Password input controller
  bool _isLoading = false; // Loading state for async operations
  String? _selectedCountry; // Selected country from dropdown
  
  final List<String> _countries = [
    'Nigeria', 'Kenya', 'Rwanda', 'Ghana', 'South Africa', 'Uganda', 'Tanzania',
    'Ethiopia', 'Morocco', 'Egypt', 'Algeria', 'Tunisia', 'Cameroon', 'Ivory Coast',
    'Senegal', 'Mali', 'Burkina Faso', 'Niger', 'Guinea', 'Benin', 'Togo',
    'Sierra Leone', 'Liberia', 'Mauritania', 'Gambia', 'Cape Verde'
  ];

  /**
   * Clean up controllers when widget is disposed
   * Prevents memory leaks
   */
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /**
   * Handle sign up form submission
   * Validates form, creates user account, and navigates to home screen on success
   */
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          displayName: _nameController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please check your email to verify your account.'),
              backgroundColor: kPrimaryColor,
              duration: Duration(seconds: 5),
            ),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isSmallScreen ? 16 : 24),
              Center(
                child: Text(
                  "Sign Up",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6585D3),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildNameField(),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildEmailField(),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildCountryField(),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildPasswordField(),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6585D3),
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              const Center(
                child: Text(
                  "Or sign up with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              _buildSocialButton(
                iconPath: 'assets/google_logo.png',
                label: "Continue with Google",
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                isGoogle: true,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.login);
                    },
                    child: const Text(
                      "Sign in",
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

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Full Name", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          validator: validateName,
          decoration: const InputDecoration(
            hintText: "Input your full name",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

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

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Country", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return _countries;
            }
            return _countries.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            setState(() {
              _selectedCountry = selection;
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              validator: (value) => _selectedCountry == null ? 'Please select a country' : null,
              decoration: const InputDecoration(
                hintText: "Select or type country",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
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
        icon: Image.asset(
          'assets/google_logo.png',
          width: isSmallScreen ? 20 : 24,
          height: isSmallScreen ? 20 : 24,
        ),
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
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          try {
            await GoogleAuthService.signInWithGoogle();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Google sign-in failed: $e')),
              );
            }
          }
        },
      ),
    );
  }
}