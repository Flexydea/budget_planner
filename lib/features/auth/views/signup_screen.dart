import 'package:budget_planner/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_planner/core/utils/currency.dart';
import 'package:budget_planner/core/widgets/currency_picker.dart';
import 'package:budget_planner/core/widgets/section_card.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Currency _selectedCurrency = kCurrencies.first;
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _currencyC = TextEditingController();
  final _limitC = TextEditingController(text: '5000');
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _currencyC.text = '${_selectedCurrency.name} (${_selectedCurrency.symbol})';
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _currencyC.dispose();
    _limitC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passC.text != _confirmC.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    try {
      await context.read<AuthProvider>().signUp(
        _nameC.text.trim(),
        _emailC.text.trim(),
        _passC.text,
      );

      // 🔍 Debug: Check what got saved
      // final email = await AuthService.currentEmail();
      // final name = await AuthService.currentName();
      // debugPrint('Saved user: $name <$email>');

      if (!mounted) return;
      context.go('/'); // success → Home
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<AuthProvider>().error ?? 'Sign up failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/icons/app_icon.png', height: 80),
                const SizedBox(height: 20),
                Text(
                  'Get Started',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'It only takes a minute to start taking hold of your finances',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),

                // section form card feel
                SectionCard(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameC,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your email';
                          final emailReg = RegExp(
                            r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$',
                          );
                          return emailReg.hasMatch(v)
                              ? null
                              : 'Enter a valid email';
                        },
                      ),
                      TextFormField(
                        controller: _currencyC,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        onTap: () async {
                          final choice = await showCurrencyPicker(
                            context,
                            selected: _selectedCurrency,
                          );
                          if (choice != null) {
                            setState(() => _selectedCurrency = choice);
                            _currencyC.text =
                                '${choice.name} (${choice.symbol})';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _limitC,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              'Daily limit (${_selectedCurrency.symbol})',
                        ),
                      ),
                      TextFormField(
                        controller: _passC,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: 'Create Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        validator: (v) => v == null || v.length < 6
                            ? 'Min 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmC,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                        validator: (v) => v == null || v.length < 6
                            ? 'Min 6 characters'
                            : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do you have an account? "),
                    GestureDetector(
                      onTap: () => context.go('/auth/login'),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: scheme.primary,
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
}
