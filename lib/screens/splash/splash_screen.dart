import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _navigateNext(),
    );
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();

    final bool hasCompletedOnboarding =
        prefs.getBool('onboarding_complete') ?? false;
    final bool isLoggedIn =
        prefs.getBool('is_logged_in') ?? false;

    print(
      '🎯 onboarding_complete: $hasCompletedOnboarding',
    );
    print('🎯 is_logged_in: $isLoggedIn');

    if (!mounted) return;

    if (!hasCompletedOnboarding) {
      context.go('/onboarding');
    } else if (!isLoggedIn) {
      context.go('/register');
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/images/app_icon1.png',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}
