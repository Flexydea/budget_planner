import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_planner/core/utils/currency.dart';
import 'package:budget_planner/core/widgets/currency_picker.dart';

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
  final _currencyC = TextEditingController(text: 'Dollar (\$)');
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_passC.text != _confirmC.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // App logo
                Image.asset(
                  'assets/icons/app_icon.png', // Your app logo path
                  height: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'Get Started',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'It only takes a minute to start taking hold of your finances',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                // Name
                TextFormField(
                  controller: _nameC,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    final emailReg = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
                    return emailReg.hasMatch(v) ? null : 'Enter a valid email';
                  },
                ),
                const SizedBox(height: 15),

                // Currency
                TextFormField(
                  controller: _currencyC,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () async {
                    // ELS10: open picker and wait for result
                    final choice = await showCurrencyPicker(
                      context,
                      selected: _selectedCurrency,
                    );
                    if (choice != null) {
                      setState(() => _selectedCurrency = choice);
                      _currencyC.text = '${choice.name} (${choice.symbol})';
                    }
                  },
                ),
                const SizedBox(height: 15),

                // Daily limit
                TextFormField(
                  controller: _limitC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Daily limit (\$)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Create Password
                TextFormField(
                  controller: _passC,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'Create Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                TextFormField(
                  controller: _confirmC,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 25),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1A237E,
                      ), // Deep blue from logo
                      foregroundColor: Colors.white, // White text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // TODO: Handle create account action
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
