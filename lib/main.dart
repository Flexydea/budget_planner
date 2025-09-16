import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/app.dart';
import 'package:budget_planner/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
