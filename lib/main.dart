import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/app.dart';
import 'package:budget_planner/features/auth/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const BudgetApp(),
    ),
  );
}
