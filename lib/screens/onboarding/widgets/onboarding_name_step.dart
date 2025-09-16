import 'package:flutter/material.dart';

class OnboardingNameStep extends StatefulWidget {
  final TextEditingController nameController;
  final VoidCallback onNext;

  const OnboardingNameStep({
    super.key,
    required this.nameController,
    required this.onNext,
  });

  @override
  State<OnboardingNameStep> createState() =>
      _OnboardingNameStepState();
}

class _OnboardingNameStepState
    extends State<OnboardingNameStep> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "WHAT'S YOUR NAME?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: widget.nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      setState(
                        () {},
                      ); // rebuild so button updates live
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  widget.nameController.text.trim().isEmpty
                  ? null
                  : widget.onNext,
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
                "Next",
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
