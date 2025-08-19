import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  bool isSpentSelected = true;
  bool isGridView = false;

  final Map<String, int> categoryTransactionCounts = {
    '👚 Shopping': 3,
    '🚘 Travel': 1,
    '🍕 Food': 5,
    '💊 Medicine': 2,
    '💸 Cash': 0,
    '🏓 Sport': 4,
    '📚 Education': 2,
    '🔘 Other': 0,
    '💼 Salary': 1,
    '🎁 Bonus': 0,
    '💰 Refund': 2,
    '🏦 Interest': 3,
    '📦 Sales': 2,
    '🎉 Gift': 1,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeList = isSpentSelected
        ? categoryTransactionCounts.keys
              .where((k) => !k.contains('Salary') && !k.contains('Gift'))
              .toList()
        : categoryTransactionCounts.keys
              .where((k) => k.contains('Salary') || k.contains('Gift'))
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isGridView ? Icons.list : Icons.grid_view,
                key: ValueKey<bool>(isGridView),
              ),
            ),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              // Tabs
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isSpentSelected = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSpentSelected
                              ? const Color(0xFF1A237E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Spent',
                          style: TextStyle(
                            color: isSpentSelected
                                ? Colors.white
                                : scheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isSpentSelected = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isSpentSelected
                              ? const Color(0xFF1A237E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: !isSpentSelected
                                ? Colors.white
                                : scheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // List or Grid
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isGridView
                      ? GridView.builder(
                          key: const ValueKey('grid'),
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                          itemCount: activeList.length,
                          itemBuilder: (context, i) {
                            final cat = activeList[i];
                            final count = categoryTransactionCounts[cat] ?? 0;

                            return GestureDetector(
                              onTap: () {
                                // Navigate to transaction detail screen (to be implemented)
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: scheme.outlineVariant,
                                    width: 0.12,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.15),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: count > 0
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                '$count',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cat.split(' ')[0],
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          cat.split(' ').sublist(1).join(' '),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.separated(
                          key: const ValueKey('list'),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemCount: activeList.length,
                          itemBuilder: (context, i) {
                            final cat = activeList[i];
                            final count = categoryTransactionCounts[cat] ?? 0;

                            return GestureDetector(
                              onTap: () {
                                // Navigate to transaction detail screen (to be implemented)
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: scheme.outlineVariant,
                                    width: 0.12,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.15),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      cat.split(' ')[0],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.split(' ').sublist(1).join(' '),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Tap to view transactions',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (count > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
