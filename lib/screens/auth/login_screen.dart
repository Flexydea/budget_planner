// File: auth/login_screen.dart
import 'package:budget_planner/screens/auth/widgets/forgot_password_dialog.dart';
import 'package:budget_planner/screens/auth/widgets/sign_in_options.dart';
import 'package:budget_planner/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/utils/user_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("saved_email");

    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  // Show error dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Login Failed"),
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

  // Login logic
  Future<void> _login() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await context.read<AuthProvider>().signIn(
        email,
        password,
      );

      //  Get the logged-in Firebase user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await setCurrentUser(
          user.uid,
        ); // store unique user ID
      }

      //  Handle remember-me
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString("saved_email", email);
      } else {
        await prefs.remove("saved_email");
      }

      //  Navigate to home
      await prefs.setBool('is_logged_in', true);
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email format.";
          break;
        case 'wrong-password':
        case 'user-not-found':
          message =
              "Invalid credentials. Please try again.";
          break;
        default:
          message = e.message ?? "Authentication error.";
      }
      _showError(message);
    } catch (_) {
      _showError("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // App icon
                    Image.asset(
                      'assets/images/app_icon_raw.png',
                      width: 80,
                      height: 80,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface,
                    ),

                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Please enter your details to login.',
                    ),
                    const SizedBox(height: 20),

                    // Form fields
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(
                                  labelText: 'Email',
                                  border:
                                      OutlineInputBorder(),
                                ),
                            keyboardType:
                                TextInputType.emailAddress,
                          ),

                          Align(
                            alignment:
                                Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const ForgotPasswordDialog(),
                                );
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border:
                                  const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword =
                                        !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(
                                    () => _rememberMe =
                                        value!,
                                  );
                                },
                              ),
                              const Text('Remember me'),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading
                                  ? null
                                  : _login, // disable when loading
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        10,
                                      ),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors
                                            .white, // 👈 always visible
                                      ),
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary, // 👈 always correct contrast
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          SignInOptions(), // social logins
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register link
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.push('/register'),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
