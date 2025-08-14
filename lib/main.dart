import 'package:flutter/material.dart';
import 'package:budget_planner/app.dart';

void main() {
  //Ensure flutter is ready (needed before async or plugins)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BudgetApp()); // Lucnch root widget
}
