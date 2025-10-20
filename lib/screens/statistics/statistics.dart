import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:budget_planner/utils/currency_utils.dart';
import 'package:budget_planner/utils/user_utils.dart';

class MyStatistics extends StatefulWidget {
  const MyStatistics({super.key});

  @override
  State<MyStatistics> createState() => _MyStatisticsState();
}

class _MyStatisticsState extends State<MyStatistics> {
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  String currencySymbol = '£';

  List<Map<String, dynamic>> topCategories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await loadCurrentUser();
    final code = await getUserCurrency(currentUserId);
    currencySymbol = currencySymbolOf(code);

    final transactions =
        HiveTransactionService.getAllTransactions();

    double income = 0;
    double expense = 0;
    Map<String, double> categoryTotals = {};

    // Calculate totals and category grouping
    for (var txn in transactions) {
      if (txn.type == 'Income') {
        income += txn.amount;
      } else if (txn.type == 'Expense') {
        expense += txn.amount;

        // Sum per category
        categoryTotals[txn.category] =
            (categoryTotals[txn.category] ?? 0) +
            txn.amount;
      }
    }

    // Sort categories by highest amount spent
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Match icons from AvailableIcons
    topCategories = sortedCategories.take(4).map((entry) {
      final category = entry.key;
      final iconMap = AvailableIcons.firstWhere(
        (icon) =>
            (icon['name'] as String).toLowerCase() ==
            category.toLowerCase(),
        orElse: () => {'icon': FontAwesomeIcons.circle},
      );

      return {
        'icon': iconMap['icon'],
        'name': category,
        'amount': entry.value,
        'date': 'Recent',
      };
    }).toList();

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      totalBalance = income - expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = NumberFormat.simpleCurrency(
      name: currencySymbol,
    );

    // Unified theme colors for pie slices
    final primary = colorScheme.primary;
    final pieColors = [
      primary.withOpacity(0.9),
      primary.withOpacity(0.7),
      primary.withOpacity(0.5),
      primary.withOpacity(0.3),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Summary Row ----
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _summaryCard(
                  context,
                  'Balance',
                  currency.format(totalBalance),
                  colorScheme.onSurface,
                ),
                _summaryCard(
                  context,
                  'Income',
                  '+${currency.format(totalIncome)}',
                  Colors.greenAccent.shade400,
                ),
                _summaryCard(
                  context,
                  'Expense',
                  '-${currency.format(totalExpense)}',
                  Colors.redAccent.shade200,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ---- Pie Chart ----
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: PieChart(
                  PieChartData(
                    sections: _buildPieSections(
                      pieColors,
                      colorScheme,
                    ),
                    centerSpaceRadius: 60,
                    sectionsSpace: 2,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ---- Top Categories ----
            Text(
              'Top Spending Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),

            // ---- Transaction-style List ----
            Expanded(
              flex: 2,
              child: topCategories.isEmpty
                  ? Center(
                      child: Text(
                        'No expense data yet',
                        style: TextStyle(
                          color: colorScheme.onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: topCategories.length,
                      itemBuilder: (context, index) {
                        final c = topCategories[index];
                        final amountColor =
                            Colors.redAccent.shade200;
                        final bgColor = colorScheme.surface
                            .withOpacity(0.9);
                        final iconColor =
                            colorScheme.onPrimary;

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              // Left side — icon + text
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color:
                                          pieColors[index %
                                              pieColors
                                                  .length],
                                      borderRadius:
                                          BorderRadius.circular(
                                            10,
                                          ),
                                    ),
                                    child: Icon(
                                      c['icon'] as IconData,
                                      color: iconColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        c['name'] as String,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          color: colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        c['date'] as String,
                                        style: TextStyle(
                                          color: colorScheme
                                              .onSurface
                                              .withOpacity(
                                                0.6,
                                              ),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Right side — amount
                              Text(
                                "-${currency.format(c['amount'])}",
                                style: TextStyle(
                                  color: amountColor,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary Cards
  Widget _summaryCard(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: colors.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pie Chart Sections — dynamic data
  List<PieChartSectionData> _buildPieSections(
    List<Color> pieColors,
    ColorScheme colorScheme,
  ) {
    if (topCategories.isEmpty) return [];

    return topCategories.asMap().entries.map((entry) {
      final index = entry.key;
      final cat = entry.value;

      return PieChartSectionData(
        color: pieColors[index % pieColors.length],
        value: cat['amount'] as double,
        title: cat['name'] as String,
        radius: 70,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      );
    }).toList();
  }
}
