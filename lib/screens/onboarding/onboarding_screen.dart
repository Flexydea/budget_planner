// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/onboarding_name_step.dart';
import 'widgets/onboarding_dob_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  // Track current page (0 = name, 1 = dob)
  int _currentStep = 0;

  // Controllers and state
  final TextEditingController _nameController =
      TextEditingController();
  DateTime _dob = DateTime.now();

  // Save the name in SharedPreferences
  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "user_name",
      _nameController.text.trim(),
    );
  }

  // Save DOB in SharedPreferences
  Future<void> _saveDob() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "user_dob",
      _dob.toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentStep == 0
          // STEP 1: Name
          ? OnboardingNameStep(
              nameController: _nameController,
              onNext: () async {
                await _saveName();
                setState(
                  () => _currentStep = 1,
                ); // move to DOB step
              },
            )
          // STEP 2: DOB
          : OnboardingDobStep(
              selectedDate: _dob,
              onDateChanged: (date) =>
                  setState(() => _dob = date),
              onFinish: () async {
                await _saveDob();

                if (mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                  );
                }
              },
            ),
    );
  }
}
