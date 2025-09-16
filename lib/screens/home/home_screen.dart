import 'dart:math';

import 'package:budget_planner/screens/Expense/AddExpense.dart';
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
  var widgetScreenList = [
    MainScreen(),
    MyStatistics(),
    TipsScreen(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          selectedItemColor: Theme.of(
            context,
          ).colorScheme.primary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'statistics',
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
        ).colorScheme.primary, // FAB background
        foregroundColor: Theme.of(
          context,
        ).colorScheme.onPrimary, // auto icon/text color
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        onPressed: () {
          context.push('/add-expense');
        },
        child: const Icon(
          CupertinoIcons.add,
          // color: Colors.white,
        ),
      ),
      body: index == 0
          ? MainScreen()
          : index == 1
          ? MyStatistics()
          : TipsScreen(),
    );
  }
}
