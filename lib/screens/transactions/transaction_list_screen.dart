import 'package:budget_planner/utils/currency_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/utils/user_utils.dart';

class TransactionListScreen extends StatefulWidget {
  final String categoryName;

  const TransactionListScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState
    extends State<TransactionListScreen> {
  //  Local state
  List<TransactionModel> transactions = [];
  List<Map<String, dynamic>>? userCategoriesCache;
  final Map<String, IconData> categoryIcons =
      {}; //  name -> icon (lowercased key)
  String _currencySymbol = '£';

  @override
  void initState() {
    super.initState();
    _loadCurrencySymbol();
    _initIconsAndData(); //  build icon cache + load txns
  }

  Future<void> _loadCurrencySymbol() async {
    await loadCurrentUser(); // ensure user ID is available
    final code = await getUserCurrency(currentUserId);
    final symbol = currencySymbolOf(code);
    if (!mounted) return;
    setState(() {
      _currencySymbol = symbol;
    });
  }

  ///  Build icon cache (defaults + user) + load transactions
  Future<void> _initIconsAndData() async {
    await loadCurrentUser();

    // 1) Start with defaults
    categoryIcons.clear();
    for (final item in AvailableIcons) {
      final name = (item['name'] as String)
          .trim()
          .toLowerCase();
      final icon = item['icon'] as IconData;
      categoryIcons[name] = icon;
    }

    // 2) Merge user's categories by NAME → canonical icon
    final userCats = await loadUserCategoriesForUser(
      currentUserId,
    );
    for (final cat in userCats) {
      final name = ((cat['name'] ?? '') as String)
          .trim()
          .toLowerCase();
      if (name.isEmpty) continue;

      // Find the canonical icon from AvailableIcons by name
      final match = AvailableIcons.firstWhere(
        (m) =>
            ((m['name'] as String).trim().toLowerCase()) ==
            name,
        orElse: () => {'icon': Icons.category},
      );
      final iconData = match['icon'] as IconData;

      // Overwrite (or add) ensuring same icon used everywhere
      categoryIcons[name] = iconData;
    }

    // 3) Load txns for this category
    transactions =
        HiveTransactionService.getTransactionsByCategory(
          widget.categoryName,
        )..sort((a, b) => b.date.compareTo(a.date));

    if (mounted) setState(() {});
  }

  ///  Get icon for category name (smart + onboarding compatible)
  IconData _getCategoryIcon(String categoryName) {
    final key = categoryName.trim().toLowerCase();
    // direct match
    final direct = categoryIcons[key];
    if (direct != null) return direct;

    // fuzzy (spaces/punct removed) as a last resort
    final simplified = key.replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );
    for (final e in categoryIcons.entries) {
      final k = e.key.replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (k == simplified) return e.value;
    }
    return Icons.category;
  }

  ///  Delete transaction + undo
  Future<void> _deleteTransaction(
    TransactionModel txn,
  ) async {
    await HiveTransactionService.deleteTransaction(txn.id);
    await _initIconsAndData(); //  refresh list + icons

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await HiveTransactionService.addTransaction(
              txn,
            );
            await _initIconsAndData();
          },
        ),
      ),
    );
  }

  ///  Format date — show “Today”, otherwise dd/MM/yy
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference =
        DateTime(now.year, now.month, now.day)
            .difference(
              DateTime(date.year, date.month, date.day),
            )
            .inDays;

    if (difference == 0) return "Today";
    //  per your spec: for yesterday, show actual date as well
    return DateFormat('dd/MM/yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      //  Empty state with Lottie animation
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty_box.json',
                    width: 300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add one from the + button',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                final isIncome = txn.type == "Income";
                final amountColor = isIncome
                    ? Colors.green
                    : Colors.red;

                return Dismissible(
                  key: ValueKey(txn.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  onDismissed: (_) =>
                      _deleteTransaction(txn),
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        //  Left side — icon + description
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.circular(
                                      10,
                                    ),
                              ),
                              child: Icon(
                                _getCategoryIcon(
                                  txn.category,
                                ),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  txn.description.isNotEmpty
                                      ? txn.description
                                      : widget.categoryName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(txn.date),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        //  Right side — amount
                        Text(
                          "${isIncome ? '+' : '-'}$_currencySymbol${txn.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: amountColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary,
        foregroundColor: Theme.of(
          context,
        ).colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () => context.push('/add-expense'),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
