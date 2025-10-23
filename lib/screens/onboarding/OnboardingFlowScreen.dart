import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/onboarding_category_step.dart';
import 'widgets/onboarding_name_step.dart';
import 'widgets/onboarding_currency_step.dart';

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
  String? _selectedCurrency;
  final TextEditingController _nameController =
      TextEditingController();
  List<Map<String, dynamic>> _selectedCategories = [];

  Future<void> _nextPage() async {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),
          LinearProgressIndicator(
            value: (_currentPage + 1) / _totalSteps,
            backgroundColor: Colors.grey[300],
            color: Colors.black,
            minHeight: 4,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
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
                OnboardingCurrencyStep(
                  selectedCurrency: _selectedCurrency,
                  onCurrencyChanged: (v) =>
                      setState(() => _selectedCurrency = v),
                  onFinish: _nextPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
