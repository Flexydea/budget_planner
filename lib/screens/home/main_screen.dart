import 'package:budget_planner/providers/theme_provider.dart';
import 'package:budget_planner/services/user_prefs.dart';
import 'package:budget_planner/utils/currency_utils.dart';
import 'package:budget_planner/utils/user_utils.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:budget_planner/widgets/BalanceCardWidget.dart';
import 'package:budget_planner/widgets/TransactionItemTile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _userName;
  String _currencySymbol = '£';
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<TransactionModel> _transactions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await loadCurrentUser();

    // Load user name
    final savedName = await loadUserName();

    // Load currency
    final code = await getUserCurrency(currentUserId);
    final symbol = currencySymbolOf(code);

    // Load all transactions
    final txns =
        HiveTransactionService.getAllTransactions();

    double income = 0;
    double expense = 0;
    for (final t in txns) {
      if (t.type == 'Income') income += t.amount;
      if (t.type == 'Expense') expense += t.amount;
    }

    if (!mounted) return;
    setState(() {
      _userName = savedName;
      _currencySymbol = symbol;
      _totalIncome = income;
      _totalExpense = expense;
      _transactions = List.from(txns)
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  double get _balance => _totalIncome - _totalExpense;

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final parts = name.trim().split(" ");
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                        child: Text(
                          _getInitials(_userName),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "${_userName ?? "User"} 👋",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () =>
                        context.push('/settings'),
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Your existing card — untouched visually
              BalanceCard(
                totalBalance: _balance,
                totalIncome: _totalIncome,
                totalExpense: _totalExpense,
                currencySymbol: _currencySymbol,
              ),

              const SizedBox(height: 40),

              // Header row stays the same
              if (_transactions.isNotEmpty)
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // If empty, show your animation
              if (_transactions.isEmpty)
                Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/empty_box.json',
                      width: 220,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No transactions yet",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    // Use your exact TransactionItemTile widget
                    return const MyListviewTile();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
