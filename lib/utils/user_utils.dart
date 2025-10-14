import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:budget_planner/models/transaction_model.dart';

///  Prefix for per-user category storage
const String _kUserCategoriesKeyPrefix = 'user_categories_';

/// Holds the currently active user ID (defaults to demo for testing)
String currentUserId = 'demo_user';

Map<String, dynamic>? _encodeIconData(IconData? icon) {
  if (icon == null) return null;
  return {
    'codePoint': icon.codePoint,
    'fontFamily': icon.fontFamily,
    'fontPackage': icon.fontPackage,
    'matchTextDirection': icon.matchTextDirection,
  };
}

IconData? _decodeIconData(dynamic map) {
  // If null, nothing to decode
  if (map == null) return null;

  // Case 1: already IconData-like map
  if (map is Map<String, dynamic>) {
    final cp = map['codePoint'];
    if (cp is int) {
      return IconData(
        cp,
        fontFamily: map['fontFamily'] as String?,
        fontPackage: map['fontPackage'] as String?,
        matchTextDirection:
            map['matchTextDirection'] ?? false,
      );
    }
  }

  // Case 2: previously saved as raw integer (legacy onboarding)
  if (map is int) {
    // try matching with AvailableIcons to recover
    final match = AvailableIcons.firstWhere(
      (c) => (c['icon'] as IconData).codePoint == map,
      orElse: () => {'icon': Icons.category},
    );
    return match['icon'] as IconData;
  }

  return Icons.category;
}

///  Save user categories (per specific user)
Future<void> saveUserCategoriesForUser(
  String userId,
  List<Map<String, dynamic>> selected,
) async {
  final prefs = await SharedPreferences.getInstance();

  final encoded = selected.map((cat) {
    final icon = cat['icon'];
    return {
      'name': cat['name'],
      'icon': _encodeIconData(
        icon is IconData ? icon : null,
      ),
    };
  }).toList();

  await prefs.setString(
    '$_kUserCategoriesKeyPrefix$userId',
    jsonEncode(encoded),
  );
}

Future<void> clearDemoTransactions() async {
  final txns = HiveTransactionService.getAllTransactions();
  if (txns.isNotEmpty) {
    for (final txn in txns) {
      await HiveTransactionService.deleteTransaction(
        txn.id,
      );
    }
    debugPrint(
      'Cleared demo transactions before creating new user.',
    );
  }
}

Future<void> normalizeUserCategories(String userId) async {
  final cats = await loadUserCategoriesForUser(userId);
  if (cats.isNotEmpty) {
    await saveUserCategoriesForUser(userId, cats);
  }
}

///  Load categories for a given user
Future<List<Map<String, dynamic>>>
loadUserCategoriesForUser(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(
    '$_kUserCategoriesKeyPrefix$userId',
  );

  if (saved == null) return [];

  final List decoded = jsonDecode(saved);
  return decoded.map<Map<String, dynamic>>((item) {
    final name = item['name'] ?? '';
    final iconMap = item['icon'];
    final iconData = (iconMap is Map)
        ? _decodeIconData(
            Map<String, dynamic>.from(iconMap),
          )
        : _findDefaultIcon(name);
    return {'name': name, 'icon': iconData};
  }).toList();
}

/// 🔍 Fallback icon
IconData _findDefaultIcon(String name) {
  final match = AvailableIcons.firstWhere(
    (m) =>
        (m['name'] as String).trim().toLowerCase() ==
        name.trim().toLowerCase(),
    orElse: () => {'icon': Icons.category},
  );
  return match['icon'] as IconData;
}

///  Add a new category for the current user (avoid duplicates)
Future<void> addUserCategory({
  required String name,
  required IconData icon,
}) async {
  final list = await loadUserCategoriesForUser(
    currentUserId,
  );

  final exists = list.any(
    (c) =>
        (c['name'] as String).trim().toLowerCase() ==
        name.trim().toLowerCase(),
  );

  if (!exists) {
    list.add({'name': name.trim(), 'icon': icon});
    await saveUserCategoriesForUser(currentUserId, list);
  }
}

Future<void> setCurrentUser(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('current_user', userId);
  currentUserId = userId;
  // debugPrint('👤 Current user set: $userId');
}

Future<void> loadCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();
  currentUserId =
      prefs.getString('current_user') ?? 'demo_user';
}

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
  currentUserId = 'demo_user';
  // debugPrint('👋 User logged out. Reset to demo_user.');
}

/// Move categories from demo_user (onboarding) to the actual user UID after registration.
Future<void> migrateDemoCategoriesToUser(
  String userId,
) async {
  final prefs = await SharedPreferences.getInstance();
  final demoList = await loadUserCategoriesForUser(
    'demo_user',
  );
  if (demoList.isEmpty) return;

  // Save under real user ID
  await saveUserCategoriesForUser(userId, demoList);

  // Clean up demo cache
  await prefs.remove(
    '${_kUserCategoriesKeyPrefix}demo_user',
  );
  // debugPrint(' Migrated onboarding categories to $userId');
}

Future<void> deleteUserCategory(String categoryName) async {
  await loadCurrentUser();
  final list = await loadUserCategoriesForUser(
    currentUserId,
  );

  // Remove from local category list
  final updated = list
      .where(
        (c) =>
            c['name'].toLowerCase() !=
            categoryName.toLowerCase(),
      )
      .toList();

  await saveUserCategoriesForUser(currentUserId, updated);

  // 🧾 Remove all transactions tied to that category
  final allTxns =
      HiveTransactionService.getAllTransactions();
  final remaining = allTxns
      .where(
        (t) =>
            t.category.toLowerCase() !=
            categoryName.toLowerCase(),
      )
      .toList();

  await HiveTransactionService.replaceAllTransactions(
    remaining,
  );

  print(
    '🧾 Deleted category "$categoryName" and related transactions removed.',
  );
}
