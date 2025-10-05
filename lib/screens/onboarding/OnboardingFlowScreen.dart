import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/onboarding_category_step.dart';
import 'widgets/onboarding_name_step.dart';
import 'widgets/onboarding_dob_step.dart';
import 'package:budget_planner/core/theme/app_theme.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState
    extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 3;

  List<Map<String, dynamic>> _selectedCategories = [];
  final TextEditingController _nameController =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(
        '/register',
        extra: _nameController.text.trim(),
      );
    }
  }

  void _toggleCategory(Map<String, dynamic> category) {
    final exists = _selectedCategories.any(
      (cat) => cat['name'] == category['name'],
    );

    setState(() {
      if (exists) {
        _selectedCategories.removeWhere(
          (cat) => cat['name'] == category['name'],
        );
      } else if (_selectedCategories.length < 6) {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 40),
            LinearProgressIndicator(
              value: (_currentPage + 1) / _totalSteps,
              backgroundColor: Colors.grey[300],
              color: Colors.black,
              minHeight: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(),
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                children: [
                  OnboardingCategoryStep(
                    selectedCategories: _selectedCategories,
                    onToggleCategory: _toggleCategory,
                    onNext: _nextPage,
                  ),
                  OnboardingNameStep(
                    nameController: _nameController,
                    onNext: _nextPage,
                  ),
                  OnboardingDobStep(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) => setState(
                      () => _selectedDate = date,
                    ),
                    onFinish: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
