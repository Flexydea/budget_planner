import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budget_planner/models/data/data.dart';

class OnboardingCategoryStep extends StatelessWidget {
  final List<String> selectedTitles;
  final Function(String) onToggleCategory;
  final VoidCallback onNext;

  const OnboardingCategoryStep({
    super.key,
    required this.selectedTitles,
    required this.onToggleCategory,
    required this.onNext,
  });

  bool _isSelected(String title) =>
      selectedTitles.contains(title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'What do you likely spend on the most?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select up to 6 categories   ${selectedTitles.length}/6',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: AvailableIcons.map((category) {
                  final IconData icon = category['icon'];
                  final String title = category['name'];
                  final bool selected = _isSelected(title);

                  return GestureDetector(
                    onTap: () => onToggleCategory(title),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(
                            0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: selected
                                ? Colors.white
                                : Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(
                                  maxWidth: 100,
                                ),
                            child: Text(
                              title,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (selected)
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Icon(
                                CupertinoIcons
                                    .clear_circled_solid,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedTitles.isNotEmpty
                  ? onNext
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
                'Next',
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
