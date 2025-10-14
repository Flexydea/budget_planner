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

  // Case 1: already IconData-like map (from onboarding)
  if (map is Map<String, dynamic>) {
    final cp = map['codePoint'];
    if (cp is int) {
      // ✅ Ensure font family is recognized by FontAwesome
      final family =
          map['fontFamily'] ?? 'FontAwesomeSolid';
      final pkg =
          map['fontPackage'] ?? 'font_awesome_flutter';

      return IconData(
        cp,
        fontFamily: family,
        fontPackage: pkg,
        matchTextDirection:
            map['matchTextDirection'] ?? false,
      );
    }
  }

  // Case 2: legacy saved as raw integer (old onboarding)
  if (map is int) {
    // Match using AvailableIcons list
    final match = AvailableIcons.firstWhere(
      (c) => (c['icon'] as IconData).codePoint == map,
      orElse: () => {'icon': Icons.category},
    );
    return match['icon'] as IconData;
  }

  // Default fallback
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

    // ✅ Force proper structure for any icon source
    IconData iconData;

    if (icon is IconData) {
      iconData = icon;
    } else if (icon is Map) {
      // Try decoding from map
      final cp = icon['codePoint'] ?? 0xe14c;
      iconData = IconData(
        cp,
        fontFamily:
            icon['fontFamily'] ?? 'FontAwesomeSolid',
        fontPackage:
            icon['fontPackage'] ?? 'font_awesome_flutter',
        matchTextDirection:
            icon['matchTextDirection'] ?? false,
      );
    } else {
      // Lookup from AvailableIcons (fallback)
      final match = AvailableIcons.firstWhere(
        (c) =>
            (c['name'] as String).toLowerCase() ==
            (cat['name'] as String).toLowerCase(),
        orElse: () => {'icon': Icons.category},
      );
      iconData = match['icon'] as IconData;
    }

    // ✅ Encode consistently with correct FontAwesome info
    return {
      'name': cat['name'],
      'icon': {
        'codePoint': iconData.codePoint,
        'fontFamily':
            iconData.fontFamily ?? 'FontAwesomeSolid',
        'fontPackage':
            iconData.fontPackage ?? 'font_awesome_flutter',
        'matchTextDirection': iconData.matchTextDirection,
      },
    };
  }).toList();

  await prefs.setString(
    '$_kUserCategoriesKeyPrefix$userId',
    jsonEncode(encoded),
  );
  print('💾 Saved normalized categories for $userId');
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

/// 🧩 Normalize user categories — ensures icon maps become real IconData again
Future<void> normalizeUserCategories(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('user_categories_$userId');
  if (saved == null) return;

  final List decoded = jsonDecode(saved);
  final normalized = decoded.map<Map<String, dynamic>>((
    item,
  ) {
    final name = item['name'] ?? '';
    final iconMap = item['icon'];
    final iconData = (iconMap is Map)
        ? _decodeIconData(
            Map<String, dynamic>.from(iconMap),
          )
        : _findDefaultIcon(name);
    return {'name': name, 'icon': iconData};
  }).toList();

  await prefs.setString(
    'user_categories_$userId',
    jsonEncode(
      normalized.map((c) {
        final icon = c['icon'];
        return {
          'name': c['name'],
          'icon': _encodeIconData(
            icon is IconData ? icon : null,
          ),
        };
      }).toList(),
    ),
  );

  print('✅ Normalized category icons for $userId');
}

/// 🧩 Normalize all category icons after migration (for onboarding fix)
Future<void> normalizeCategoryIcons(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(
    '$_kUserCategoriesKeyPrefix$userId',
  );

  if (saved == null) return;

  final List decoded = jsonDecode(saved);
  final normalized = decoded.map((item) {
    final name = item['name'] ?? '';
    final iconMap = item['icon'];

    IconData iconData;

    if (iconMap is IconData) {
      iconData = iconMap;
    } else if (iconMap is Map) {
      iconData = IconData(
        iconMap['codePoint'] ?? 0xe14c,
        fontFamily:
            iconMap['fontFamily'] ?? 'FontAwesomeSolid',
        fontPackage:
            iconMap['fontPackage'] ??
            'font_awesome_flutter',
        matchTextDirection:
            iconMap['matchTextDirection'] ?? false,
      );
    } else {
      final match = AvailableIcons.firstWhere(
        (c) =>
            (c['name'] as String).toLowerCase() ==
            (name as String).toLowerCase(),
        orElse: () => {'icon': Icons.category},
      );
      iconData = match['icon'] as IconData;
    }

    return {
      'name': name,
      'icon': {
        'codePoint': iconData.codePoint,
        'fontFamily':
            iconData.fontFamily ?? 'FontAwesomeSolid',
        'fontPackage':
            iconData.fontPackage ?? 'font_awesome_flutter',
        'matchTextDirection': iconData.matchTextDirection,
      },
    };
  }).toList();

  await prefs.setString(
    '$_kUserCategoriesKeyPrefix$userId',
    jsonEncode(normalized),
  );

  print('✅ Normalized category icons for $userId');
}

///  Load categories for a given user
Future<List<Map<String, dynamic>>>
loadUserCategoriesForUser(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final key = '$_kUserCategoriesKeyPrefix$userId';
  final saved = prefs.getString(key);

  if (saved == null) {
    print('⚠️ No categories found for $userId');
    return [];
  }

  final List decoded = jsonDecode(saved);
  List<Map<String, dynamic>> categories = [];

  for (final item in decoded) {
    final name = item['name'] ?? '';
    final iconMap = item['icon'];

    IconData? iconData;

    // ✅ 1️⃣ Decode existing icon map (normal path)
    if (iconMap is Map<String, dynamic>) {
      try {
        iconData = IconData(
          iconMap['codePoint'] ?? 0xe14c,
          fontFamily:
              iconMap['fontFamily'] ?? 'FontAwesomeSolid',
          fontPackage:
              iconMap['fontPackage'] ??
              'font_awesome_flutter',
          matchTextDirection:
              iconMap['matchTextDirection'] ?? false,
        );
      } catch (_) {}
    }

    // ✅ 2️⃣ Recover using AvailableIcons if missing or invalid
    if (iconData == null || iconData.codePoint == 0xe14c) {
      final match = AvailableIcons.firstWhere(
        (c) =>
            (c['name'] as String).toLowerCase() ==
            name.toLowerCase(),
        orElse: () => {'icon': Icons.category},
      );
      iconData = match['icon'] as IconData;
    }

    categories.add({'name': name, 'icon': iconData});
  }

  // ✅ 3️⃣ Re-save fixed icons so they persist properly next time
  final repaired = categories.map((c) {
    final i = c['icon'] as IconData;
    return {
      'name': c['name'],
      'icon': {
        'codePoint': i.codePoint,
        'fontFamily': i.fontFamily,
        'fontPackage': i.fontPackage,
        'matchTextDirection': i.matchTextDirection,
      },
    };
  }).toList();

  await prefs.setString(key, jsonEncode(repaired));
  print(
    '✅ Normalized and repaired category icons for $userId',
  );

  return categories;
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

  // 🧩 Normalize immediately after migration
  await normalizeCategoryIcons(userId);

  print('✅ Migrated and normalized categories for $userId');
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
