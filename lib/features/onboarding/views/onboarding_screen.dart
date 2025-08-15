import 'package:budget_planner/data/services/prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageC = PageController(); // controlls page changes
  int _index = 0;

  final _slides = const [
    (
      'assets/images/onboarding/step1.svg',
      'Take hold of your finances',
      "Running your finances doesn't have to be hard.",
    ),
    (
      'assets/images/onboarding/step3.svg',
      'Reach your goals with ease',
      'Budget makes it a breeze to save and grow.',
    ),
    (
      'assets/images/onboarding/step2.svg',
      'See where your money is going',
      'Track automatically with bank sync or manually—then analyze.',
    ),
  ];
  @override
  void dispose() {
    _pageC.dispose(); //frees controller memory
    super.dispose();
  }

  void _next() {
    if (_index < _slides.length - 1) {
      _pageC.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _back() {
    if (_index > 0) {
      _pageC.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _skip() => _finish();

  void _finish() async {
    await PrefsService.setOnboarded(); //rember onboarding done
    if (!mounted) return;
    context.go('/auth/signup'); // go to create account
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _slides.length - 1;

    return Scaffold(
      appBar: AppBar(
        //show back arrow except on first page
        leading: _index > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back)
            : null,

        //progress bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / _slides.length,
            backgroundColor: const Color(0xFF1A237E),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageC,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final (asset, title, subtitle) = _slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // SVG illustration
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            asset,
                            width: 260,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            .7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          // dots + button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: active ? 24 : 6,
                      decoration: BoxDecoration(
                        color: active
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withOpacity(.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        // Text color for Skip
                      ),
                      onPressed: _skip,
                      child: const Text('Skip'),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _next,
                      child: Text(isLast ? "Let's Start" : 'Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
