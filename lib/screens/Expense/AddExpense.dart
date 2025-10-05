import 'package:budget_planner/models/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:budget_planner/utils/user_utils.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController =
      TextEditingController();
  TextEditingController categoryController =
      TextEditingController();
  TextEditingController dateController =
      TextEditingController();
  DateTime selectDate = DateTime.now();

  String? selectedType;
  IconData? selectedIcon;
  String? selectedCategory;

  final List<String> typeOptions = ['Income', 'Expense'];
  List<Map<String, dynamic>> userCategories = [];

  @override
  void initState() {
    dateController.text = DateFormat(
      'dd/MM/yy',
    ).format(DateTime.now());
    _loadUserCategories();
    super.initState();
  }

  Future<void> _loadUserCategories() async {
    final list = await loadUserCategories();
    if (!mounted) return;
    setState(() => userCategories = list);
  }

  @override
  void dispose() {
    expenseController.dispose();
    categoryController.dispose();
    dateController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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

                // Amount field
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.5,
                  child: TextFormField(
                    controller: expenseController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surface,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.sterlingSign,
                        size: 16,
                      ),
                      hintText: 'Amount',
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

                // Income or Expense field (bottom sheet)
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedType ?? '',
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.exchangeAlt,
                      size: 16,
                    ),
                    hintText: 'Select Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () async {
                    final selected =
                        await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          shape:
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.vertical(
                                      top: Radius.circular(
                                        20,
                                      ),
                                    ),
                              ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                16,
                              ),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    'Select Type',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons
                                          .arrowUp,
                                      color: Colors.green,
                                    ),
                                    title: const Text(
                                      'Income',
                                    ),
                                    onTap: () =>
                                        Navigator.pop(
                                          context,
                                          'Income',
                                        ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      FontAwesomeIcons
                                          .arrowDown,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      'Expense',
                                    ),
                                    onTap: () =>
                                        Navigator.pop(
                                          context,
                                          'Expense',
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                    if (selected != null) {
                      setState(
                        () => selectedType = selected,
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Category field
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    if (userCategories.isNotEmpty) {
                      final selected = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surface,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      userCategories.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing:
                                            16,
                                      ),
                                  itemBuilder: (context, index) {
                                    final cat =
                                        userCategories[index];
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.pop(
                                            context,
                                            cat,
                                          ),
                                      child: Column(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.all(
                                                  14,
                                                ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.background,
                                              shape: BoxShape
                                                  .circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors
                                                      .black
                                                      .withOpacity(
                                                        0.05,
                                                      ),
                                                  blurRadius:
                                                      4,
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
                                                  Icons
                                                      .category,
                                              size: 22,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            cat['name'],
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
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
                          );
                        },
                      );

                      if (selected != null) {
                        setState(() {
                          selectedCategory =
                              selected['name'];
                          selectedIcon = selected['icon'];
                          categoryController.text =
                              selected['name'];
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "No saved categories. Add one using +",
                          ),
                        ),
                      );
                    }
                  },
                  controller: categoryController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.list,
                      size: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        size: 16,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            final TextEditingController
                            nameController =
                                TextEditingController();
                            IconData? pickedIcon;
                            bool isExpanded = false;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text(
                                    'Create a Category',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller:
                                              nameController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor:
                                                Theme.of(
                                                      context,
                                                    )
                                                    .colorScheme
                                                    .surface,
                                            hintText:
                                                'Name',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  ),
                                              borderSide:
                                                  BorderSide
                                                      .none,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          onTap: () => setState(
                                            () => isExpanded =
                                                !isExpanded,
                                          ),
                                          textAlignVertical:
                                              TextAlignVertical
                                                  .center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor:
                                                Theme.of(
                                                      context,
                                                    )
                                                    .colorScheme
                                                    .surface,
                                            suffixIcon: Row(
                                              mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                              children: [
                                                if (pickedIcon !=
                                                    null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      right:
                                                          8.0,
                                                    ),
                                                    child: Icon(
                                                      pickedIcon,
                                                      size:
                                                          20,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                    ),
                                                  ),
                                                const Icon(
                                                  CupertinoIcons
                                                      .chevron_down,
                                                ),
                                              ],
                                            ),
                                            hintText:
                                                'Icon',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  isExpanded
                                                  ? const BorderRadius.vertical(
                                                      top: Radius.circular(
                                                        12,
                                                      ),
                                                    )
                                                  : BorderRadius.circular(
                                                      12,
                                                    ),
                                              borderSide:
                                                  BorderSide
                                                      .none,
                                            ),
                                          ),
                                        ),
                                        isExpanded
                                            ? Container(
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                                  borderRadius: const BorderRadius.vertical(
                                                    bottom:
                                                        Radius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: GridView.builder(
                                                  shrinkWrap:
                                                      true,
                                                  itemCount:
                                                      AvailableIcons
                                                          .length,
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        3,
                                                    crossAxisSpacing:
                                                        8,
                                                    mainAxisSpacing:
                                                        8,
                                                    childAspectRatio:
                                                        1,
                                                  ),
                                                  itemBuilder:
                                                      (
                                                        context,
                                                        index,
                                                      ) {
                                                        final iconMap =
                                                            AvailableIcons[index];
                                                        final iconData =
                                                            iconMap['icon']
                                                                as IconData;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(
                                                              () {
                                                                pickedIcon = iconData;
                                                                isExpanded = false;
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(
                                                                5,
                                                              ),
                                                              border: Border.all(
                                                                color:
                                                                    pickedIcon ==
                                                                        iconData
                                                                    ? Theme.of(
                                                                        context,
                                                                      ).colorScheme.primary
                                                                    : Theme.of(
                                                                        context,
                                                                      ).dividerColor,
                                                                width:
                                                                    pickedIcon ==
                                                                        iconData
                                                                    ? 2
                                                                    : 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                iconData,
                                                                size: 28,
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: double
                                              .infinity,
                                          height:
                                              kToolbarHeight,
                                          child: TextButton(
                                            onPressed: () async {
                                              final name =
                                                  nameController
                                                      .text
                                                      .trim();
                                              if (name.isEmpty ||
                                                  pickedIcon ==
                                                      null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text(
                                                          'Please enter a name and select an icon.',
                                                        ),
                                                  ),
                                                );
                                                return;
                                              }

                                              final newCategory = {
                                                'name':
                                                    name,
                                                'icon':
                                                    pickedIcon,
                                              };

                                              userCategories
                                                  .add(
                                                    newCategory,
                                                  );
                                              await saveUserCategories(
                                                userCategories,
                                              );

                                              await _loadUserCategories();
                                              Navigator.pop(
                                                context,
                                              );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '$name category added!',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              foregroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12,
                                                    ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Save',
                                              style:
                                                  TextStyle(
                                                    fontSize:
                                                        20,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    hintText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Date picker
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate =
                        await showDatePicker(
                          context: context,
                          initialDate: selectDate,
                          firstDate: DateTime.now(),
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
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface,
                    prefixIcon: Icon(
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface,
                    ),
                    hintText: 'Date',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: TextButton(
                    onPressed: () {},
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
      ),
    );
  }
}
