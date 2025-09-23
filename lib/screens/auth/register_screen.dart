import 'package:budget_planner/screens/auth/widgets/accept_terms_text.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';
import 'package:budget_planner/core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for user input
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // UI flags
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _loading = false;

  // Regex for password validation
  final RegExp _uppercase = RegExp(r'[A-Z]');
  final RegExp _lowercase = RegExp(r'[a-z]');
  final RegExp _number = RegExp(r'[0-9]');
  final RegExp _specialChar = RegExp(r'[!@#\$&*~]');

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(
      () => _obscureConfirmPassword =
          !_obscureConfirmPassword,
    );
  }

  // Account creation dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Account creation"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Registration logic
  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text
        .trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError(
        "Please enter details to create an account",
      );
      return;
    }

    if (!_acceptedTerms) {
      _showError("You must accept the terms to continue.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    //  password errors
    List<String> errors = [];
    if (password.length < 8)
      errors.add("at least 8 characters");
    if (!_uppercase.hasMatch(password))
      errors.add("an uppercase letter");
    if (!_lowercase.hasMatch(password))
      errors.add("a lowercase letter");
    if (!_number.hasMatch(password)) errors.add("a number");
    if (!_specialChar.hasMatch(password)) {
      errors.add("a special character (!@#\$&*~)");
    }

    if (errors.isNotEmpty) {
      _showError(
        "Password must include ${errors.join(', ')}.",
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<AuthProvider>().createAccount(
        email,
        password,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered.";
          break;
        case 'invalid-email':
          message = "Invalid email format.";
          break;
        case 'weak-password':
          message =
              "Password is too weak. Please choose a stronger one.";
          break;
        default:
          message = "Registration failed: ${e.message}";
      }
      _showError(message);
    } catch (e) {
      _showError("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light.copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Logo
                  Image.asset(
                    'assets/images/app_icon_raw.png',
                    width: 80,
                    height: 80,
                  ),

                  const Text(
                    "Create an account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email field
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed:
                            _togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm password field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed:
                            _toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) => setState(
                          () => _acceptedTerms = value!,
                        ),
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                      ),
                      const Expanded(
                        child: AcceptTermsText(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : _register, // disable button while loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<
                                      Color
                                    >(Colors.white),
                              ),
                            )
                          : const Text(
                              'Create an account',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link to login
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
      ),
    );
  }
}
