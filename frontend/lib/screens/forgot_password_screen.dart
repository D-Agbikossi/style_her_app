/**
 * Forgot Password Screen
 * 
 * This screen handles password reset functionality:
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

const kScaffoldBackground = Color(0xFFF5F5F5); // light gray background

const Color kPrimaryColor = Color(0xFF2C5BB1); // Main brand blue
const Color kBackgroundColor = Color(0xFFF5F9FF); // App background color

/**
 * Forgot Password Screen
 * 
 * Main widget for password reset functionality
 */
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

/**
 * Forgot Password Screen State
 * 
 * Manages form state, email input, and password reset process
 */
class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  /**
   * Clean up resources when widget is disposed
   * Prevents memory leaks by disposing controllers
   */
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /**
   * Handle password reset form submission
   * Validates email format and sends reset email
   * Shows success/error messages and navigates back on success
   */
  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
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

  /**
   * Build the forgot password screen UI
   * Includes app bar, form with email field, and reset button
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                    "Forgot Password",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: Column(children: [_buildEmailField()]),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
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
}
