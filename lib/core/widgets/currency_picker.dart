import 'package:flutter/material.dart';
import 'package:budget_planner/core/utils/currency.dart';

// ELS10: One shared list for now (move to a service if you later fetch remotely).
const kCurrencies = <Currency>[
  Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
  Currency(code: 'EUR', name: 'Euro', symbol: '€'),
  Currency(code: 'GBP', name: 'British Pound', symbol: '£'),
  Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦'),
];

// ELS10: Show a modal sheet and return the chosen Currency (or null if cancelled).
Future<Currency?> showCurrencyPicker(
  BuildContext context, {
  Currency? selected,
}) {
  return showModalBottomSheet<Currency>(
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: kCurrencies.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final c = kCurrencies[i];
            final active = selected?.code == c.code;
            return ListTile(
              title: Text(c.name),
              subtitle: Text(c.code),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(c.symbol, style: const TextStyle(fontSize: 18)),
                  if (active) const SizedBox(width: 8),
                  if (active) const Icon(Icons.check, color: Colors.green),
                ],
              ),
              onTap: () => Navigator.of(context).pop(c), // ELS10: return choice
            );
          },
        ),
      );
    },
  );
}
