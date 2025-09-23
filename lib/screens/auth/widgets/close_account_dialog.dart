import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';

class CloseAccountDialog extends StatefulWidget {
  const CloseAccountDialog({super.key});

  @override
  State<CloseAccountDialog> createState() =>
      _CloseAccountDialogState();
}

class _CloseAccountDialogState
    extends State<CloseAccountDialog> {
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  late final String providerId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    providerId =
        user?.providerData.first.providerId ??
        "password"; // default to password
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Account Closure Failed"),
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

  Future<void> _handleCloseAccount(
    BuildContext context,
  ) async {
    setState(() => _loading = true);

    try {
      if (providerId == "password") {
        // Email/password users need email + password
        await context.read<AuthProvider>().deleteAccount(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else if (providerId == "google.com") {
        // Google users: just confirm
        await context
            .read<AuthProvider>()
            .deleteGoogleAccount();
      }

      if (mounted) {
        Navigator.pop(context); // close dialog
        context.go('/login'); // go back to login
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message;
      switch (e.code) {
        case 'wrong-password':
          message = "Incorrect password. Please try again.";
          break;
        case 'user-mismatch':
          message =
              "The provided email does not match the signed-in user.";
          break;
        case 'invalid-credential':
          message =
              "Invalid credentials. Please re-enter your details.";
          break;
        default:
          message = "Failed to close account: ${e.message}";
      }
      _showError(message);
    } catch (e) {
      Navigator.pop(context);
      _showError("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Close Account"),
      content: providerId == "password"
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter your email and password to confirm account closure.",
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword =
                            !_obscurePassword,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Text(
              "Are you sure you want to close your account? This action cannot be undone.",
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _loading
              ? null
              : () => _handleCloseAccount(context),
          child: _loading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : const Text("Confirm"),
        ),
      ],
    );
  }
}
