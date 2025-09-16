// File: lib/screens/tips/tip_detail_screen.dart

import 'package:flutter/material.dart';

class TipDetailScreen extends StatelessWidget {
  final Map<String, dynamic> tip;

  const TipDetailScreen({Key? key, required this.tip})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          tip['title'] ?? '',
          style: const TextStyle(
            // color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                tip['image'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface,
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Practical Budgeting Advice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tip['description'],
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 2.0,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['tips'],
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
