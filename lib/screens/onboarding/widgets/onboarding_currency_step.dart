import 'package:flutter/material.dart';
import 'package:budget_planner/widgets/currency_dropdown.dart';

class OnboardingCurrencyStep extends StatefulWidget {
  final String? selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onFinish;

  const OnboardingCurrencyStep({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.onFinish,
  });

  @override
  State<OnboardingCurrencyStep> createState() =>
      _OnboardingCurrencyStepState();
}

class _OnboardingCurrencyStepState
    extends State<OnboardingCurrencyStep> {
  @override
  Widget build(BuildContext context) {
    final bool hasSelection =
        widget.selectedCurrency != null;

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
                    "CHOOSE YOUR CURRENCY",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  //  Centered dropdown just like the name input
                  SizedBox(
                    width: 300,
                    child: CurrencyDropdown(
                      value: widget.selectedCurrency,
                      onChanged: widget.onCurrencyChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  Bottom “Finish” button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: hasSelection
                  ? widget.onFinish
                  : null,
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
