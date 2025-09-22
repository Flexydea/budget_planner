import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState
    extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController =
      TextEditingController();
  bool _loading = false;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError("Please enter your email.");
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<AuthProvider>().resetPassword(
        email,
      );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        showDialog(
          context: context,
          useRootNavigator: true,
          builder: (ctx) => AlertDialog(
            title: const Text("Check your email"),
            content: const Text(
              "If an account with this email exists, a password reset link has been sent.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(
                  ctx,
                  rootNavigator: true,
                ).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showError("Failed to reset password. $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reset Password"),
      content: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: "Enter your email",
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _loading ? null : _resetPassword,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text("Send"),
        ),
      ],
    );
  }
}
