import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  bool isSpentSelected = true; // Toggle for Spent/Income
  String? selectedEmoji; // Stores chosen emoji
  final TextEditingController nameController =
      TextEditingController(); // Input for category name

  // Predefined emoji list
  final List<String> emojis = ['🍕', '🎁', '🚗', '💊', '📚', '🎉', '💼'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Cancel (X) button at top-right
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Wallet icon + "Add operation" title
                  Column(
                    children: const [
                      Icon(Icons.category, size: 60, color: Color(0xFF1A237E)),
                      SizedBox(height: 10),
                      Text(
                        'Add Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Visual Amount (just text, not editable here)
                  const Text(
                    '\$0.00',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),

                  // Spent / Income toggle with border
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isSpentSelected = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSpentSelected
                                    ? Colors.red
                                    : Colors.grey.withOpacity(0.4),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Spent',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isSpentSelected = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: !isSpentSelected
                                    ? Colors.green
                                    : Colors.grey.withOpacity(0.4),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Income',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Emoji Selector
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: emojis.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final emoji = emojis[index];
                        final isSelected = selectedEmoji == emoji;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedEmoji = emoji;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xFF1A237E).withOpacity(0.2)
                                  : scheme.surface,
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xFF1A237E)
                                    : scheme.outlineVariant,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Name Input Field
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Save to Hive later
                        final name = nameController.text.trim();
                        if (name.isEmpty || selectedEmoji == null) return;

                        // For now, just print result
                        print(
                          'Added: $name with $selectedEmoji as ${isSpentSelected ? "Spent" : "Income"}',
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF1A237E),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
