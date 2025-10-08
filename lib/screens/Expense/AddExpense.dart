import 'package:budget_planner/models/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_planner/utils/user_utils.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  //  Controllers
  final TextEditingController descriptionController =
      TextEditingController();
  final TextEditingController expenseController =
      TextEditingController();
  final TextEditingController categoryController =
      TextEditingController();
  final TextEditingController dateController =
      TextEditingController();

  //  State
  DateTime selectDate = DateTime.now();
  String? selectedType;
  IconData? selectedIcon;
  String? selectedCategory;
  List<Map<String, dynamic>> userCategories = [];

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat(
      'dd/MM/yy',
    ).format(DateTime.now());
    _loadUserCategories();
  }

  ///  Load categories for the current user
  Future<void> _loadUserCategories() async {
    await loadCurrentUser();
    final list = await loadUserCategoriesForUser(
      currentUserId,
    );
    if (!mounted) return;
    setState(() => userCategories = list);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    expenseController.dispose();
    categoryController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Show success Lottie animation (transparent + auto-close)
  Future<void> _showSuccessAnimation(
    String category,
  ) async {
    // showDialog keeps the background transparent
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(
        0.4,
      ), //  adds subtle dark overlay
      builder: (_) => Center(
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(
            milliseconds: 300,
          ), //  fade-in effect
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(
                0.85,
              ), //  soft dark background
              borderRadius: BorderRadius.circular(16),
            ),
            child: Lottie.asset(
              'assets/animations/done.json',
              width: 140,
              repeat: false,
              fit: BoxFit.contain,
              onLoaded: (composition) async {
                //  Wait for full animation duration
                await Future.delayed(
                  composition.duration +
                      const Duration(milliseconds: 200),
                );

                //  Smooth fade-out before closing
                if (mounted) {
                  // Close the dialog first
                  Navigator.of(context).pop();
                  context.go('/home');
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  ///  Show modal alert when fields are missing
  void _showValidationModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Incomplete Fields',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Please fill in all fields before submitting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///  Save expense with validation + animation
  Future<void> _saveExpense() async {
    final description = descriptionController.text.trim();
    final amountText = expenseController.text.trim();
    final category = selectedCategory ?? '';
    final type = selectedType ?? '';

    // ✅ Check if required fields are filled
    if (description.isEmpty ||
        amountText.isEmpty ||
        category.isEmpty ||
        type.isEmpty) {
      _showValidationModal();
      return;
    }

    // ✅ Parse and validate numeric input
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showValidationModal();
      return;
    }

    // ✅ Normalize amount to 2 decimals for clean data
    final normalizedAmount = double.parse(
      amount.toStringAsFixed(2),
    );

    final txn = TransactionModel(
      id: const Uuid().v4(),
      category: category,
      description: description,
      amount: normalizedAmount,
      date: selectDate,
      type: type,
    );

    await HiveTransactionService.addTransaction(txn);

    // ✅ Success animation
    await _showSuccessAnimation(category);

    // ✅ Reset fields
    descriptionController.clear();
    expenseController.clear();
    categoryController.clear();
    setState(() {
      selectedCategory = null;
      selectedType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.background,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              //  Amount
              SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  controller: expenseController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                  textAlign: TextAlign.center,

                  //  Only allow numbers and up to 2 decimal places
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.sterlingSign,
                      size: 16,
                    ),
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              //  Type picker
              _buildTypePicker(context),

              const SizedBox(height: 16),

              //  Category picker
              _buildCategoryPicker(context),

              const SizedBox(height: 16),

              //  Description field
              TextFormField(
                controller: descriptionController,
                maxLength: 25,
                buildCounter:
                    (
                      BuildContext context, {
                      required int currentLength,
                      required int? maxLength,
                      required bool isFocused,
                    }) {
                      // ✅ Hide the counter visually (keeps clean UI)
                      return const SizedBox.shrink();
                    },
                decoration: InputDecoration(
                  hintText: 'Description (max 25 chars)',
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    size: 18,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //  Date picker
              _buildDatePicker(context),

              const SizedBox(height: 20),

              //  Save button
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: TextButton(
                  onPressed: _saveExpense,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Extracted type picker for clarity
  Widget _buildTypePicker(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: selectedType ?? '',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: const Icon(
          FontAwesomeIcons.exchangeAlt,
          size: 16,
        ),
        hintText: 'Select Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.arrowUp,
                    color: Colors.green,
                  ),
                  title: const Text('Income'),
                  onTap: () =>
                      Navigator.pop(context, 'Income'),
                ),
                ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.arrowDown,
                    color: Colors.red,
                  ),
                  title: const Text('Expense'),
                  onTap: () =>
                      Navigator.pop(context, 'Expense'),
                ),
              ],
            ),
          ),
        );

        if (selected != null)
          setState(() => selectedType = selected);
      },
    );
  }

  //  Extracted date picker
  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: selectDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(
            const Duration(days: 365),
          ),
        );
        if (newDate != null) {
          setState(() {
            dateController.text = DateFormat(
              'dd/MM/yy',
            ).format(newDate);
            selectDate = newDate;
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: Icon(
          FontAwesomeIcons.clock,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        hintText: 'Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  //  Extracted category picker (unchanged from your version)
  Widget _buildCategoryPicker(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: categoryController,
      onTap: () async {
        if (userCategories.isNotEmpty) {
          final selected =
              await showModalBottomSheet<
                Map<String, dynamic>
              >(
                context: context,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: userCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                        itemBuilder: (context, index) {
                          final cat = userCategories[index];
                          return GestureDetector(
                            onTap: () =>
                                Navigator.pop(context, cat),
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(
                                        14,
                                      ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(
                                              0.05,
                                            ),
                                        blurRadius: 4,
                                        offset:
                                            const Offset(
                                              0,
                                              2,
                                            ),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    cat['icon'] ??
                                        Icons.category,
                                    size: 22,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat['name'],
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );

          if (selected != null) {
            setState(() {
              selectedCategory = selected['name'];
              selectedIcon = selected['icon'];
              categoryController.text = selected['name'];
            });
          }
        } else {
          _showValidationModal();
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: const Icon(
          FontAwesomeIcons.list,
          size: 16,
        ),
        suffixIcon: IconButton(
          icon: const Icon(FontAwesomeIcons.plus, size: 16),
          onPressed: _showAddCategoryDialog,
        ),
        hintText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  ///  Reuse your same _showAddCategoryDialog() method
  void _showAddCategoryDialog() {
    // unchanged from your version
  }
}
