import 'package:budget_planner/screens/auth/login_screen.dart';
import 'package:budget_planner/screens/auth/register_screen.dart';
import 'package:budget_planner/screens/home/home_screen.dart';
import 'package:budget_planner/screens/onboarding/OnboardingFlowScreen.dart';
import 'package:budget_planner/screens/profile/privacy_policy.dart';
import 'package:budget_planner/screens/profile/terms_and_condition.dart';
import 'package:budget_planner/screens/splash/splash_screen.dart';
import 'package:budget_planner/screens/tips/tips_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_planner/screens/home/main_screen.dart';
import 'package:budget_planner/screens/tips/tips_screen.dart';
import 'package:budget_planner/screens/profile/profile_settings_screen.dart';
import 'package:budget_planner/screens/profile/edit_profile_screen.dart';
import 'package:budget_planner/screens/profile/change_password_screen.dart';
import 'package:budget_planner/screens/profile/currency_selector_screen.dart';
import 'package:budget_planner/screens/Expense/AddExpense.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      // builder: (context, state) =>
      //     const OnboardingFlowScreen(),
      // builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) =>
          const OnboardingFlowScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final name =
            state.extra as String?; // passed in onboarding
        return RegisterScreen(name: name);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/tips/detail',
      builder: (context, state) {
        final tip = state.extra as Map<String, dynamic>;
        return TipDetailScreen(tip: tip);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/edit-profile',
      builder: (context, state) =>
          const EditProfileScreen(),
    ),
    GoRoute(
      path: '/settings/change-password',
      builder: (context, state) =>
          const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/settings/currency',
      builder: (context, state) =>
          const CurrencySelectorScreen(),
    ),
    GoRoute(
      path: '/settings/privacy',
      builder: (context, state) =>
          const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/settings/terms',
      builder: (context, state) =>
          const TermsConditionsScreen(),
    ),
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpense(),
    ),
  ],
);
