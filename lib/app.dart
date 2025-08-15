import 'package:flutter/material.dart';
import 'package:budget_planner/core/routing/app_router.dart';

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: use .router so GoRouter owns navigation.
    return MaterialApp.router(
      title: 'Budget Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: appRouter, // <-- this must be set
      // DO NOT set: home:, routes:, onGenerateRoute:
    );
  }
}
