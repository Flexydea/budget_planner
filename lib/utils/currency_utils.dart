import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/utils/user_utils.dart';

const kDefaultCurrencyCode = 'GBP';

//helper to find symbol by code
String currencySymbolOf(String? code) {
  if (code == null || code.isEmpty) return '£';

  try {
    final match = currencies.firstWhere(
      (c) => c['code'] == code,
      orElse: () => {'symbol': '£'},
    );
    final symbol = match['symbol'];
    if (symbol is String && symbol.isNotEmpty)
      return symbol;
    return '£';
  } catch (e) {
    return '£';
  }
}

//private per-user key
String _keyForUser(String uid) => 'currency_$uid';

//get currency user
Future<String> getUserCurrency(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_keyForUser(userId)) ??
      kDefaultCurrencyCode;
}

//set user currency

Future<void> setUserCurrency(
  String userId,
  String code,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyForUser(userId), code);
}

Future<void> migrateCurrencyFromDemoTo(
  String newUserId,
) async {
  final prefs = await SharedPreferences.getInstance();
  const demoKey = 'currency_demo_user';
  final demoCurrency = prefs.getString(demoKey);

  if (demoCurrency == null) {
    // print('⚠️ No currency found for demo_user to migrate.');
    return;
  }

  await prefs.setString(
    'currency_$newUserId',
    demoCurrency,
  );
  // print('✅ Currency migrated: $demoCurrency → $newUserId');

  // optional cleanup
  await prefs.remove(demoKey);
}
