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

  // AuthProvider
  final authProvider = AuthProvider();
  authProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();
            authProvider.init(); // listen to auth changes
            return authProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
