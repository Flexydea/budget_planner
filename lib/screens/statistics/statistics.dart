import 'package:budget_planner/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyStatistics extends StatefulWidget {
  const MyStatistics({super.key});

  @override
  State<MyStatistics> createState() => _MyStatisticsState();
}

class _MyStatisticsState extends State<MyStatistics> {
  String selected = 'Expenses';
  DateTimeRange? _selectedRange;
  String selectedView = 'Daily';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    //Income Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = 'Income';
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10),
                            color: selected == 'Income'
                                ? Colors.black
                                : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: selected == 'Income'
                                  ? Colors.green
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Expenses tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = 'Expenses';
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10),
                            color: selected == 'Expenses'
                                ? Colors.black
                                : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Expenses',
                            style: TextStyle(
                              color: selected == 'Expenses'
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Date Range Picker
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    final DateTimeRange? picked =
                        await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                    if (picked != null) {
                      setState(() {
                        // Replace with your own logic to store the selected range
                        _selectedRange = picked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            _selectedRange != null
                                ? '${DateFormat('dd/MM/yyyy').format(_selectedRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedRange!.end)}'
                                : 'Select Date Range',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              //// daily, weekly and monthly toggle
              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: ['Daily', 'Weekly', 'Monthly']
                      .map((view) {
                        final isSelected =
                            selectedView == view;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedView = view;
                            });
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey[200],
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Text(
                              view,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    20,
                    12,
                    12,
                  ),
                  //Bar chart
                  child: MyChart(
                    selectedMode: selected,
                    selectedView: selectedView,
                    selectedRange: _selectedRange,
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
