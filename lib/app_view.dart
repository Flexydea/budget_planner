import 'package:flutter/material.dart';
import 'package:budget_planner/core/routing/app_router.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Budget planner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black26,
          tertiary: Colors.white,
          outline: Colors.grey.shade400,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: appRouter,
    );
  }
}

// import 'package:budget_planner/screens/home/home_screen.dart';
// import 'package:flutter/material.dart';

// class MyAppView extends StatelessWidget {
//   const MyAppView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Budget planner',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.light(
//           primary: Colors.black,
//           secondary: Colors.black26,
//           tertiary: Colors.white,
//           outline: Colors.grey.shade400,
//         ),
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
