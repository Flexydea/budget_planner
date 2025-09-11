import 'package:budget_planner/models/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    dateController.text = DateFormat(
      'dd/MM/yy',
    ).format(DateTime.now());
    super.initState();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                      fillColor: Colors.grey[200],
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
                    fillColor: Colors.grey[200],
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
                  onTap: () {},
                  controller: categoryController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
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
                                  backgroundColor:
                                      Colors.white,
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
                                            fillColor: Colors
                                                .grey[200],
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
                                            fillColor: Colors
                                                .grey[200],

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
                                                      color:
                                                          Colors.black,
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
                                                decoration: const BoxDecoration(
                                                  color: Colors
                                                      .white,
                                                  borderRadius: BorderRadius.vertical(
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
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(
                                                                  5,
                                                                ),
                                                                border: Border.all(
                                                                  color:
                                                                      selectedIcon ==
                                                                          iconData
                                                                      ? Colors.black
                                                                      : Colors.grey.shade300,
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
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          height: 10,
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
                                                  Colors
                                                      .black,
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
                                                color: Colors
                                                    .white,
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
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(
                      FontAwesomeIcons.clock,
                      size: 16,
                    ),
                    hintText: 'Date',
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
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
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
