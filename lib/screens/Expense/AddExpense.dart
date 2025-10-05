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

                // Income or Expense dropdown
                DropdownButtonFormField<String>(
                  value: selectedType,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface,
                  ),
                  items: typeOptions.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
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
                ),

                const SizedBox(height: 16),

                // Category field
                TextFormField(
                  readOnly: true,
                  onTap: () async {
                    // Only trigger dropdown if categories exist
                    if (userCategories.isNotEmpty) {
                      final selected =
                          await showModalBottomSheet<
                            Map<String, dynamic>
                          >(
                            context:
                                context, // required parameter
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            shape:
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.vertical(
                                        top:
                                            Radius.circular(
                                              16,
                                            ),
                                      ),
                                ),
                            builder: (context) {
                              return ListView(
                                shrinkWrap: true,
                                children: userCategories
                                    .map((cat) {
                                      return ListTile(
                                        leading: Icon(
                                          cat['icon'] ??
                                              Icons
                                                  .category,
                                        ),
                                        title: Text(
                                          cat['name'],
                                        ),
                                        onTap: () =>
                                            Navigator.pop(
                                              context,
                                              cat,
                                            ),
                                      );
                                    })
                                    .toList(),
                              );
                            },
                          );

                      if (selected != null) {
                        setState(() {
                          selectedCategory =
                              selected['name'];
                          categoryController.text =
                              selected['name'];
                          selectedIcon =
                              selected['icon']; // optional
                        });
                      }
                    } else {
                      // If no categories found, show snackbar
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
