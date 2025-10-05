import 'package:budget_planner/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_planner/app.dart';
import 'package:budget_planner/providers/theme_provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadCurrentUser();

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_categories');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); // Wait before app starts

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
