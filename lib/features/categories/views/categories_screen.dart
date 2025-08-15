import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_planner/core/widgets/section_card.dart';
// import 'package:budget_planner/features/categories/providers/category_provider.dart';
import 'package:budget_planner/data/models/expense_category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Categories')));
  }
}
