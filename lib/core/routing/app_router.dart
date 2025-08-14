// UPDATED: set initial route to splash and add a route for it.
import 'package:go_router/go_router.dart';
import 'package:budget_planner/features/splash/views/splash_screen.dart'; // NEW
// import 'package:budget_planner/features/home/views/home_shell.dart';
// import 'package:budget_planner/features/expenses/views/expense_editor_screen.dart';
// import 'package:budget_planner/features/categories/views/add_category_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash', // UPDATED
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()), // NEW
    // GoRoute(path: '/', builder: (c, s) => const HomeShell()),
    // GoRoute(path: '/expense/new', builder: (c, s) => const ExpenseEditorScreen()),
    // GoRoute(path: '/category/new', builder: (c, s) => const AddCategoryScreen()),
  ],
);
