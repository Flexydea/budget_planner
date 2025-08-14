import 'package:flutter/material.dart';
import 'package:budget_planner/features/splash/views/splash_screen.dart';
// import 'home_screen.dart'; // or onboarding later

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        // '/home': (context) => const HomeScreen(), // temporary
      },
    );
  }
}
