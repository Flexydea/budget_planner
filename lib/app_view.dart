import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/core/theme/app_theme.dart';
import 'package:budget_planner/core/routing/app_router.dart';
import 'package:budget_planner/providers/theme_provider.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context
        .watch<ThemeProvider>()
        .isDarkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Budget Planner',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
