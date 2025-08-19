import 'package:budget_planner/features/auth/views/forgot_password_screen.dart';
import 'package:budget_planner/features/auth/views/login_screen.dart';
import 'package:budget_planner/features/auth/views/signup_screen.dart';
import 'package:budget_planner/features/home/views/home_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_planner/features/splash/views/splash_screen.dart';
import 'package:budget_planner/features/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(
      path: '/auth/signup',
      builder: (_, __) => const SignUpScreen(),
    ), // NEW
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: '/auth/forgot',
      builder: (_, __) => const ForgotPasswordScreen(),
    ), // NEW
    GoRoute(path: '/', builder: (_, __) => const HomeShell()),
    GoRoute(
      path: '/expense/new',
      builder: (_, __) => const Placeholder(),
    ), // wire later
    GoRoute(path: '/category/new', builder: (_, __) => const Placeholder()),
  ],
);

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Hello World')),
    );
  }
}
