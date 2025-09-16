import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/onboarding_category_step.dart';
import 'widgets/onboarding_name_step.dart';
import 'widgets/onboarding_dob_step.dart';
import 'package:budget_planner/core/theme/app_theme.dart'; // import your AppTheme

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
  List<String> _selectedCategories = [];
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
      context.push('/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light, // light theme here
      child: Scaffold(
        backgroundColor: Colors.white, //  white always
        body: Column(
          children: [
            const SizedBox(height: 40),
            const SizedBox(height: 40),
            // Moving progress bar
            LinearProgressIndicator(
              value: (_currentPage + 1) / _totalSteps,
              backgroundColor:
                  Colors.grey[300], // softer grey
              color: Colors.black, // progress bar black
              minHeight: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  OnboardingCategoryStep(
                    selectedTitles: _selectedCategories,
                    onToggleCategory: (title) {
                      setState(() {
                        if (_selectedCategories.contains(
                          title,
                        )) {
                          _selectedCategories.remove(title);
                        } else if (_selectedCategories
                                .length <
                            6) {
                          _selectedCategories.add(title);
                        }
                      });
                    },
                    onNext: _nextPage,
                  ),
                  OnboardingNameStep(
                    nameController: _nameController,
                    onNext: _nextPage,
                  ),
                  OnboardingDobStep(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() => _selectedDate = date);
                    },
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
