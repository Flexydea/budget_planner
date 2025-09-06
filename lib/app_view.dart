import 'package:budget_planner/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget planner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.blueAccent,
          tertiary: Colors.white,
          outline: Colors.grey.shade400,
        ),
        scaffoldBackgroundColor: Colors.grey[350],
      ),
      home: HomeScreen(),
    );
  }
}
