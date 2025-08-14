import 'package:flutter/material.dart';
import 'package:budget_planner/core/routing/app_router.dart';

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    //use material router for now to add go_router later now
    return MaterialApp.router(
      title: 'Budget Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: appRouter, // points to our new router
    );
  }
}
