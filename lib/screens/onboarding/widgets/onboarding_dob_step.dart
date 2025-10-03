import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingDobStep extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onFinish;

  const OnboardingDobStep({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onFinish,
  });

  @override
  State<OnboardingDobStep> createState() =>
      _OnboardingDobStepState();
}

class _OnboardingDobStepState
    extends State<OnboardingDobStep> {
  late DateTime _localDate;

  @override
  void initState() {
    super.initState();
    _localDate =
        widget.selectedDate; // start with default date
  }

  //opens date picker and updates local + parent
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _localDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _localDate = picked);
      widget.onDateChanged(picked);
    }
  }

  //Saves DOB to SharedPreferences
  Future<void> _saveDobAndFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "user_dob",
      _localDate.toIso8601String(),
    );

    // continue onboarding flow
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// Centered DOB question
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "WHEN WERE YOU BORN?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Tap to pick a date
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Text(
                        DateFormat(
                          "MMMM d, yyyy",
                        ).format(_localDate),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Finish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _saveDobAndFinish, // Save and Finish
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Finish",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
