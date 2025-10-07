import 'package:hive/hive.dart';
import 'package:budget_planner/models/transaction_model.dart';

class HiveTransactionService {
  static final _box = Hive.box<TransactionModel>(
    'transactions',
  );

  ///  Add transaction
  static Future<void> addTransaction(
    TransactionModel txn,
  ) async {
    await _box.put(txn.id, txn);
  }

  ///  Get all transactions
  static List<TransactionModel> getAllTransactions() {
    return _box.values.toList();
  }

  ///  Get transactions by category
  static List<TransactionModel> getTransactionsByCategory(
    String category,
  ) {
    return _box.values
        .where(
          (t) =>
              t.category.toLowerCase() ==
              category.toLowerCase(),
        )
        .toList();
  }

  ///  Delete transaction
  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  ///  Clear all transactions
  static Future<void> clearAll() async {
    await _box.clear();
  }
}
