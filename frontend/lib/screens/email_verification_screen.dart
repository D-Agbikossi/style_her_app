import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/auth_bloc.dart';
import '../main.dart';
import 'package:frontend/routes.dart'; // <-- ADD THIS IMPORT

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 100, color: kPrimaryColor),
              const SizedBox(height: 30),
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryText,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'We sent a verification link to your email address. Please check your email and click the link to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final authProvider = Provider.of<AuthBloc>(
                      context,
                      listen: false,
                    );
                    await authProvider.user?.reload();

                    // This check needs to be safe, so we re-fetch the user
                    final user = authProvider.user;
                    if (user != null && user.emailVerified) {
                      // --- THIS IS THE FIX ---
                      // Don't pop. Navigate to the next step.
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.interest);
                      // --- END FIX ---
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Email not verified yet. Please check your email.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('I\'ve Verified My Email'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthBloc>(
                    context,
                    listen: false,
                  );
                  await authProvider.resendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email sent!')),
                  );
                },
                child: const Text(
                  'Resend Verification Email',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthBloc>(
                    context,
                    listen: false,
                  );
                  await authProvider.signOut();
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
