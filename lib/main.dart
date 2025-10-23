import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/firebase_options.dart';
import 'package:budget_planner/providers/theme_provider.dart';
import 'package:budget_planner/providers/auth_provider.dart';
import 'package:budget_planner/app_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) {
            final auth = AuthProvider();
            auth.init();
            return auth;
          },
        ),
      ],
      child: const MyAppView(),
    ),
  );
}
