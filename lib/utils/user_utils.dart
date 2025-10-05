import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/models/data/data.dart';

const _kUserCategoriesKey =
    'user_categories'; // keeping same key for compatibility

// Encode IconData into a JSON-friendly map.
Map<String, dynamic>? _encodeIconData(IconData? icon) {
  if (icon == null) return null;
  return {
    'codePoint': icon.codePoint,
    'fontFamily': icon.fontFamily,
    'fontPackage': icon.fontPackage,
    'matchTextDirection': icon.matchTextDirection,
  };
}

// Decode IconData back from map (null-safe).
IconData? _decodeIconData(dynamic data) {
  if (data == null) return null;
  if (data is! Map) return null;

  final map = Map<String, dynamic>.from(data);
  final cp = map['codePoint'];
  if (cp is! int) return null;

  return IconData(
    cp,
    fontFamily: map['fontFamily'] as String?,
    fontPackage: map['fontPackage'] as String?,
    matchTextDirection:
        (map['matchTextDirection'] as bool?) ?? false,
  );
}

//  Save full list (each item: {name: String, icon: IconData}).
Future<void> saveUserCategories(
  List<Map<String, dynamic>> categories,
) async {
  final prefs = await SharedPreferences.getInstance();

  // Normalize + encode icons
  final encoded = categories.map((c) {
    final String name = (c['name'] ?? '').toString();
    final IconData? icon = c['icon'] as IconData?;
    return {'name': name, 'icon': _encodeIconData(icon)};
  }).toList();

  await prefs.setString(
    _kUserCategoriesKey,
    jsonEncode(encoded),
  );
}

//  Load list back as {name: String, icon: IconData}. Handles legacy formats and migrates them.
Future<List<Map<String, dynamic>>>
loadUserCategories() async {
  final prefs = await SharedPreferences.getInstance();

  //  Try to detect legacy StringList format safely
  try {
    final legacyList = prefs.getStringList(
      _kUserCategoriesKey,
    );
    if (legacyList != null) {
      // Map legacy names → icons
      final result = legacyList.map<Map<String, dynamic>>((
        name,
      ) {
        final clean = name.trim().toLowerCase();
        final match = AvailableIcons.firstWhere(
          (m) =>
              (m['name'] as String).trim().toLowerCase() ==
              clean,
          orElse: () => {
            'icon': Icons.category,
            'name': name,
          },
        );
        return {
          'name': name,
          'icon':
              match['icon'] as IconData? ?? Icons.category,
        };
      }).toList();

      // Migrate to new format
      await saveUserCategories(result);
      await prefs.remove(_kUserCategoriesKey);
      return result;
    }
  } catch (_) {
    // If getStringList throws (old format stored as String)
  }

  // 👇 Step 2: Handle new JSON format
  final saved = prefs.getString(_kUserCategoriesKey);
  if (saved == null) return [];

  final List decoded;
  try {
    decoded = jsonDecode(saved) as List;
  } catch (_) {
    // Corrupt or mismatched format, clear it
    await prefs.remove(_kUserCategoriesKey);
    return [];
  }

  final result = decoded.map<Map<String, dynamic>>((item) {
    final map = Map<String, dynamic>.from(item as Map);
    final String name = (map['name'] ?? '').toString();
    IconData? icon = _decodeIconData(map['icon']);

    if (icon == null) {
      final clean = name.trim().toLowerCase();
      final match = AvailableIcons.firstWhere(
        (m) =>
            (m['name'] as String).trim().toLowerCase() ==
            clean,
        orElse: () => {'icon': Icons.category},
      );
      icon = match['icon'] as IconData? ?? Icons.category;
    }

    return {'name': name, 'icon': icon};
  }).toList();

  // Re-save in the new structure
  await saveUserCategories(result);
  return result;
}

// Helper to append a single category (prevents duplicates by name).
Future<void> addUserCategory({
  required String name,
  required IconData icon,
}) async {
  final list = await loadUserCategories();

  // prevent duplicates (case-insensitive trim)
  final exists = list.any(
    (c) =>
        (c['name'] as String).trim().toLowerCase() ==
        name.trim().toLowerCase(),
  );
  if (!exists) {
    list.add({'name': name.trim(), 'icon': icon});
    await saveUserCategories(list);
  }
}
