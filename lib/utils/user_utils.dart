import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/models/data/data.dart';

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

IconData? _decodeIconData(Map<String, dynamic>? map) {
  if (map == null) return null;
  final cp = map['codePoint'];
  if (cp is! int) return null;

  return IconData(
    cp,
    fontFamily: map['fontFamily'] as String?,
    fontPackage: map['fontPackage'] as String?,
    matchTextDirection: map['matchTextDirection'] ?? false,
  );
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
