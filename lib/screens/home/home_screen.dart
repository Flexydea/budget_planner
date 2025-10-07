import 'package:budget_planner/screens/Expense/AddExpense.dart';
import 'package:budget_planner/screens/category/category_tab.dart';
import 'package:budget_planner/screens/home/main_screen.dart';
import 'package:budget_planner/screens/statistics/statistics.dart';
import 'package:budget_planner/screens/tips/tips_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final widgetScreenList = [
    MainScreen(),
    MyStatistics(),
    CategoryTab(),
    TipsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetScreenList[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) => setState(() => index = value),
          selectedItemColor: Theme.of(
            context,
          ).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 3,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.lightbulb),
              label: 'Tips',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary,
        foregroundColor: Theme.of(
          context,
        ).colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () => context.push('/add-expense'),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
