/**
 * Forgot Password Screen
 * * This screen handles password reset functionality:
 * - Email input form for password reset
 * - Form validation for email format
 * - Password reset request handling
 * - Loading states and error handling
 * - Navigation back to login screen
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider imports
import '../blocs/auth_bloc.dart';
import '../utils/validators.dart';

// Theme imports
import '../main.dart';

const kScaffoldBackground = Colors.white; // Changed to white to match image
// Updated to match the specific lighter blue in your screenshot
const Color kBrandBlue = Color(0xFF6B86C2);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

/**
 * Forgot Password Screen State
 * * Manages form state, email input, and password reset process
 */
class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthBloc>(context, listen: false);
        await authProvider.resetPassword(_emailController.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
          Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        backgroundColor: kScaffoldBackground,
        elevation: 0,
        // Using generic arrow back logic, ensured color is black
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centered items
              children: [
                const SizedBox(height: 100), // Spacing from top
                // UPDATED: Title Text matched to image
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kBrandBlue, // The specific blue color
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                Form(
                  key: _formKey,
                  child: Column(children: [_buildEmailField()]),
                ),

                const SizedBox(height: 30),

                // UPDATED: Button matched to image
                SizedBox(
                  width: double.infinity,
                  height: 55, // Fixed height for solid look
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBrandBlue, // Blue background
                      foregroundColor: Colors.white, // White text
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Rounded corners
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Reset Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hidden label if you want it exactly like the minimalist screenshot
        // or keep it for accessibility. I kept it clean as requested.
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          decoration: InputDecoration(
            hintText: "Input email address",
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBrandBlue),
            ),
          ),
        ),
      ],
    );
  }
}
