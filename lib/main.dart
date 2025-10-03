import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_planner/app.dart';
import 'package:budget_planner/providers/theme_provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider();
  await themeProvider
      .loadTheme(); // ✅ Wait before app starts

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            authProvider.init();
            return authProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
