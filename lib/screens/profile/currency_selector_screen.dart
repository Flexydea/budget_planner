import 'package:budget_planner/models/data/data.dart';
import 'package:flutter/material.dart';
import 'package:budget_planner/utils/currency_utils.dart';
import 'package:budget_planner/utils/user_utils.dart';

class CurrencySelectorScreen extends StatefulWidget {
  const CurrencySelectorScreen({super.key});

  @override
  State<CurrencySelectorScreen> createState() =>
      _CurrencySelectorScreenState();
}

class _CurrencySelectorScreenState
    extends State<CurrencySelectorScreen> {
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _loadUserCurrency();
  }

  Future<void> _loadUserCurrency() async {
    await loadCurrentUser();
    final code = await getUserCurrency(currentUserId);
    if (!mounted) return;
    setState(() => _selectedCurrency = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Currency')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          final isSelected =
              _selectedCurrency == currency['code'];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Colors.black,
                      width: 1.2,
                    )
                  : null,
            ),
            child: ListTile(
              leading: Text(
                currency['symbol']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                currency['code']!,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle)
                  : null,
              onTap: () async {
                final code = currency['code']!;
                setState(() => _selectedCurrency = code);

                // Save selected currency for this user
                await loadCurrentUser();
                await setUserCurrency(currentUserId, code);

                // Return to previous screen and pass the code if needed
                Navigator.pop(context, code);
              },
            ),
          );
        },
      ),
    );
  }
}
