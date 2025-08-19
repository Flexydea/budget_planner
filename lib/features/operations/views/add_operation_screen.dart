import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddOperationScreen extends StatefulWidget {
  const AddOperationScreen({super.key});

  @override
  State<AddOperationScreen> createState() => _AddOperationScreenState();
}

class _AddOperationScreenState extends State<AddOperationScreen> {
  bool isSpentSelected = true;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  // Dummy category list (replace later with your Hive list)
  final List<String> spentCategories = [
    'Shopping',
    'Food',
    'Medicine',
    'Travel',
  ];

  final List<String> incomeCategories = ['Salary', 'Gift', 'Sales'];

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final List<String> activeCategories = isSpentSelected
        ? spentCategories
        : incomeCategories;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Cancel button (X)
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

                  // Wallet icon + Title
                  Column(
                    children: const [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 60,
                        color: Color(0xFF1A237E),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Add Operation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Editable Amount
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '\$0.00',
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Spent / Income toggle
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSpentSelected = true;
                              selectedCategory =
                                  null; // Reset the dropdown when switching
                            });
                          },
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
                            child: const Text('Spent'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSpentSelected = false;
                              selectedCategory =
                                  null; // Reset the dropdown when switching
                            });
                          },
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
                            child: const Text('Income'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title input
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category dropdown
                  DropdownButtonFormField<String>(
                    value: activeCategories.contains(selectedCategory)
                        ? selectedCategory
                        : null,
                    items: activeCategories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date and time picker
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat.yMMMd().add_jm().format(selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate + save logic
                        final title = titleController.text.trim();
                        final amount =
                            double.tryParse(amountController.text.trim()) ?? 0;

                        if (title.isEmpty ||
                            amount <= 0 ||
                            selectedCategory == null) {
                          // Show error
                          return;
                        }

                        print(
                          'Added: $title \$${amount.toStringAsFixed(2)} as ${isSpentSelected ? 'Spent' : 'Income'} in $selectedCategory on $selectedDate',
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
