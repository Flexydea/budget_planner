// File: lib/screens/tips_screen.dart

import 'package:budget_planner/models/data/data.dart';
import 'package:budget_planner/screens/tips/tips_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TipsScreen extends StatefulWidget {
  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  List<Map<String, dynamic>> _filteredTips = tips;

  void _filterTips(String query) {
    final filtered = tips.where((tip) {
      final title = tip['title']!.toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredTips = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Tips',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterTips,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  icon: const Icon(Icons.search),

                  // Cancel/Clear button appears only when there is text
                  suffixIcon:
                      _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterTips(
                              '',
                            ); // Reset the filtered tips
                          },
                        )
                      : null,
                ),
              ),
            ),
            // const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _filteredTips.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                itemBuilder: (context, index) {
                  final tip = _filteredTips[index];
                  return InkWell(
                    onTap: () {
                      context.push(
                        '/tips/detail',
                        extra: tip,
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12),
                              child: Image.asset(
                                tip['image'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            tip['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
