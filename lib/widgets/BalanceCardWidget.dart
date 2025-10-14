import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final String currencySymbol;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.currencySymbol,
  });
  String formatAmount(double amount) {
    // If 1 million or more → compact display
    if (amount >= 1000000) {
      // Divide and format to 1 decimal (e.g. 2.5M)
      final compactValue = (amount / 1000000)
          .toStringAsFixed(1);
      // Remove trailing .0 for clean look (e.g. 2M instead of 2.0M)
      return '${compactValue.endsWith('.0') ? compactValue.replaceAll('.0', '') : compactValue}M';
    }

    // Otherwise → show normal amount with commas and hide .00
    final formatted = NumberFormat(
      '#,##0.00',
      'en_GB',
    ).format(amount);
    return formatted.endsWith('.00')
        ? formatted.replaceAll('.00', '')
        : formatted;
  }

  // String formatCompact(double amount) {
  //   if (amount >= 1000000) {
  //     return '${(amount / 1000000).toStringAsFixed(1)}M';
  //   } else if (amount >= 1000) {
  //     return '${(amount / 1000).toStringAsFixed(1)}K';
  //   } else {
  //     return formatAmount(amount);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$currencySymbol ${formatAmount(totalBalance)}',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                // Income
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.arrow_up,
                          size: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$currencySymbol ${formatAmount(totalIncome)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Expenses
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.arrow_down,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expenses',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$currencySymbol ${formatAmount(totalExpense)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
