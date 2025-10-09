import 'package:flutter/foundation.dart';
import 'package:budget_planner/utils/currency_utils.dart';
import 'package:budget_planner/utils/user_utils.dart';

class CurrencyNotifier extends ChangeNotifier {
  String _code = 'GBP';
  String _symbol = '£';

  String get code => _code;
  String get symbol => _symbol;

  Future<void> load() async {
    await loadCurrentUser();
    final c = await getUserCurrency(currentUserId);
    _code = c;
    _symbol = currencySymbolOf(c);
    notifyListeners();
  }

  Future<void> update(String newCode) async {
    await loadCurrentUser();
    await setUserCurrency(currentUserId, newCode);
    _code = newCode;
    _symbol = currencySymbolOf(newCode);
    notifyListeners();
  }
}
