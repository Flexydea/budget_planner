import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budget_planner/models/data/data.dart';

/// ✅ Save user's selected categories (name + icon reference)
Future<void> saveUserCategories(
  List<Map<String, dynamic>> selected,
) async {
  final prefs = await SharedPreferences.getInstance();

  // ELS10: Store category name (for display) and icon name (for lookup)
  final encoded = selected.map((cat) {
    return {
      'name': cat['name'].trim(),
      'iconName': cat['name']
          .trim(), // reuse name to match later
    };
  }).toList();

  // Save entire list as a single JSON string
  await prefs.setString(
    'user_categories',
    jsonEncode(encoded),
  );
}

/// ✅ Load categories and reattach proper icons from AvailableIcons
Future<List<Map<String, dynamic>>>
loadUserCategories() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('user_categories');

  if (saved == null) return [];

  final List decoded = jsonDecode(saved);

  // Match icon by comparing stored iconName with AvailableIcons list
  return decoded.map<Map<String, dynamic>>((item) {
    final iconName = (item['iconName'] ?? '')
        .trim()
        .toLowerCase();

    // Try to find a matching icon in your AvailableIcons list
    final match = AvailableIcons.firstWhere(
      (iconMap) =>
          iconMap['name'].trim().toLowerCase() == iconName,
      orElse: () => {
        'icon': Icons.category,
        'name': item['name'],
      },
    );

    // Return full category data including the correct IconData
    return {
      'name': item['name'],
      'icon':
          match['icon'] ??
          Icons.category, // fallback if not found
    };
  }).toList();
}

/// ✅ Optional: Use this to clear stored categories (for debugging)
Future<void> clearUserCategories() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_categories');
}
