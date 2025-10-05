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
                        TextInputType.numberWithOptions(
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

                // Income or Expense selection field
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

                  // When tapped → open sleek bottom sheet
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

                                  // List of Income / Expense
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

                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                    // If user selected something
                    if (selected != null) {
                      setState(() {
                        selectedType = selected;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Category field
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    // Only open if categories exist
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

                                // Grid of user categories
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

                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );

                      // When user selects one
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
                      // No saved categories → snackbar
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
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
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
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
                                          onTap: () {
                                            setState(() {
                                              isExpanded =
                                                  !isExpanded;
                                            });
                                          },
                                          readOnly: true,
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

                                            //displays icon selected
                                            suffixIcon: Row(
                                              mainAxisSize:
                                                  MainAxisSize
                                                      .min,
                                              children: [
                                                if (selectedIcon !=
                                                    null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      right:
                                                          8.0,
                                                    ),
                                                    child: Icon(
                                                      selectedIcon,
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
                                                  ).colorScheme.surface, // card background
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
                                                        1, // square tiles
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
                                                        final iconName =
                                                            iconMap['name']
                                                                as String;

                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(
                                                              () {
                                                                selectedIcon = iconData;
                                                                isExpanded = false;
                                                              },
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.surface,
                                                                borderRadius: BorderRadius.circular(
                                                                  5,
                                                                ),
                                                                border: Border.all(
                                                                  color:
                                                                      selectedIcon ==
                                                                          iconData
                                                                      ? Theme.of(
                                                                              context,
                                                                            )
                                                                            .colorScheme
                                                                            .primary // highlight border
                                                                      : Theme.of(
                                                                          context,
                                                                        ).dividerColor, // normal border
                                                                  width:
                                                                      selectedIcon ==
                                                                          iconData
                                                                      ? 2
                                                                      : 1,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  iconData,
                                                                  size: 30,
                                                                  color: Theme.of(
                                                                    context,
                                                                  ).colorScheme.onSurface, // adapts text/icon
                                                                ),
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
                                            onPressed:
                                                () {},
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary, // button color
                                              foregroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary, // text/icon color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12,
                                                    ),
                                              ),
                                            ),
                                            child: const Text(
                                              'save',
                                              style: TextStyle(
                                                fontSize:
                                                    22,
                                              ), // no manual color
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
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        size: 16,
                      ),
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
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surface, //  adapts light/dark
                    prefixIcon: Icon(
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface, //  adapts icon color
                    ),
                    hintText: 'Date',
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).hintColor, // proper hint text color
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
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // button background
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .onPrimary, // text/icon color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                      ), // no hardcoded color
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
