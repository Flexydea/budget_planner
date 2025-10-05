import 'package:flutter/material.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/utils/user_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingCategoryStep extends StatelessWidget {
  final List<Map<String, dynamic>> selectedCategories;
  final Function(Map<String, dynamic>) onToggleCategory;
  final VoidCallback onNext;

  const OnboardingCategoryStep({
    super.key,
    required this.selectedCategories,
    required this.onToggleCategory,
    required this.onNext,
  });

  bool _isSelected(String title) =>
      selectedCategories.any((cat) => cat['name'] == title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What do you likely spend on the most?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select up to 6 categories  ${selectedCategories.length}/6',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Category selection grid
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: AvailableIcons.map((category) {
                  final String title = category['name'];
                  final IconData icon = category['icon'];
                  final bool selected = _isSelected(title);

                  return GestureDetector(
                    onTap: () => onToggleCategory(category),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 180,
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
                          color: selected
                              ? Colors.black
                              : Colors.black.withOpacity(
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
                          Text(
                            title,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
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

          // ✅ Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedCategories.isNotEmpty
                  ? () async {
                      await loadCurrentUser();
                      final userId =
                          currentUserId ?? 'demo_user';
                      await saveUserCategoriesForUser(
                        userId,
                        selectedCategories,
                      );
                      onNext(); // continue to the name/date step
                    }
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
