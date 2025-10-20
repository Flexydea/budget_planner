import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/utils/user_utils.dart';
import 'package:budget_planner/utils/currency_utils.dart';

class MyListviewTile extends StatefulWidget {
  const MyListviewTile({super.key});

  @override
  State<MyListviewTile> createState() =>
      _MyListviewTileState();
}

class _MyListviewTileState extends State<MyListviewTile> {
  List<TransactionModel> _transactions = [];
  final Map<String, IconData> _categoryIcons = {};
  String _currencySymbol = '£';

  String formatAmount(double amount) {
    // If 1 million or more → compact display
    if (amount >= 1000000) {
      final compactValue = (amount / 1000000)
          .toStringAsFixed(1);
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ✅ NEW helper to properly decode saved icons (works for onboarding + user-created)
  IconData? _decodeIcon(dynamic iconMap) {
    if (iconMap is IconData) return iconMap;

    if (iconMap is Map) {
      return IconData(
        iconMap['codePoint'] ?? 0xe14c,
        fontFamily: iconMap['fontFamily'],
        fontPackage: iconMap['fontPackage'],
        matchTextDirection:
            iconMap['matchTextDirection'] ?? false,
      );
    }

    // Fallback for old integer storage
    if (iconMap is int) {
      final match = AvailableIcons.firstWhere(
        (m) => (m['icon'] as IconData).codePoint == iconMap,
        orElse: () => {'icon': Icons.category},
      );
      return match['icon'] as IconData;
    }

    return Icons.category;
  }

  Future<void> _loadData() async {
    await loadCurrentUser();

    // Load currency
    final code = await getUserCurrency(currentUserId);
    _currencySymbol = currencySymbolOf(code);

    // 1️⃣ Start with default icons (from data.dart)
    _categoryIcons.clear();
    for (final item in AvailableIcons) {
      final name = (item['name'] as String).toLowerCase();
      final icon = item['icon'] as IconData;
      _categoryIcons[name] = icon;
    }

    // 2️⃣ Load + decode user categories exactly like CategoryTab does
    final userCats = await loadUserCategoriesForUser(
      currentUserId,
    );

    for (final cat in userCats) {
      final name =
          (cat['name'] as String?)?.toLowerCase() ?? '';
      final iconMap = cat['icon'];

      IconData? decoded;
      if (iconMap is IconData) {
        decoded = iconMap;
      } else if (iconMap is Map) {
        decoded = IconData(
          iconMap['codePoint'] ?? 0xe14c,
          fontFamily: iconMap['fontFamily'],
          fontPackage: iconMap['fontPackage'],
          matchTextDirection:
              iconMap['matchTextDirection'] ?? false,
        );
      }

      if (decoded != null && name.isNotEmpty) {
        _categoryIcons[name] = decoded;
        debugPrint(
          ' Loaded icon for $name (${decoded.codePoint})',
        );
      }
    }

    // 3️⃣ Transactions
    final txns = HiveTransactionService.getAllTransactions()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (!mounted) return;
    setState(() => _transactions = txns);
  }

  IconData _getCategoryIcon(String category) {
    final key = category.toLowerCase().trim();
    return _categoryIcons[key] ?? FontAwesomeIcons.wallet;
  }

  Widget _buildIcon(IconData icon, Color color) {
    final isFA = (icon.fontFamily ?? '')
        .toLowerCase()
        .contains('fontawesome');
    return isFA
        ? FaIcon(icon, color: color)
        : Icon(icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No transactions yet',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, i) {
          final txn = _transactions[i];
          final isIncome = txn.type == "Income";
          final amountColor = isIncome
              ? Colors.green
              : Colors.red;
          final formattedDate = DateFormat(
            'MMM d, yyyy',
          ).format(txn.date);
          final icon = _getCategoryIcon(txn.category);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side — icon + name
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                            ),
                            _buildIcon(
                              icon,
                              Theme.of(
                                context,
                              ).colorScheme.onSurface,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          txn.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Right side — amount + date
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$_currencySymbol${formatAmount(txn.amount)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: amountColor,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
