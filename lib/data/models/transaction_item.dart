import 'package:flutter/material.dart';

class TransactionItem {
  final String title; // : e.g. "Food"
  final String subtitle; // : e.g. "Pizza Day"
  final double amount; // : negative = spent, positive = income
  final String emoji; // : simple icon proxy

  const TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.emoji,
  });

  bool get isNegative => amount < 0;
  Color trailingColor(ColorScheme scheme) =>
      isNegative ? scheme.error : const Color(0xFF2E7D32); // green-ish
}
