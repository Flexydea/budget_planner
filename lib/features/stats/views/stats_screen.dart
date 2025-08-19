import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String selectedMode = 'Spent'; // Toggle: Spent or Earned
  String selectedOverview = 'Week'; // Toggle: Week, Month, Year

  DateTime? startDate;
  DateTime? endDate;

  // Display date range text
  String get dateRangeLabel {
    if (startDate == null || endDate == null) return 'Select a date range';
    final from = DateFormat('EEE d, MMM yyyy').format(startDate!);
    final to = DateFormat('EEE d, MMM yyyy').format(endDate!);
    return '$from - $to';
  }

  // Bar chart data generator based on selected mode
  List<BarChartGroupData> getBarGroups(String mode) {
    final sampleData = mode == 'Spent'
        ? [4000, 6000, 1500, 2000, 4200, 3800, 3700]
        : [2000, 3400, 2500, 2200, 2600, 2800, 3000];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sampleData[index].toDouble(),
            width: 14,
            color: const Color(0xFF1A237E),
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }

  bool _bannerVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _bannerVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                style: text.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Time expense',
                style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              // 🔹 Lottie Animation (Banner)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _bannerVisible ? 1.0 : 0.0,
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/analytics.json',
                    height: 160,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Date Range Selector
              GestureDetector(
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: scheme.copyWith(
                            primary: const Color(0xFF1A237E),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      startDate = picked.start;
                      endDate = picked.end;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          dateRangeLabel,
                          style: text.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Your Spending Schedule Title
              Text(
                'Your spending schedule',
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Spent / Earned Toggle
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMode = 'Spent'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedMode == 'Spent'
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
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
                      onTap: () => setState(() => selectedMode = 'Earned'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedMode == 'Earned'
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Earned',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Week / Month / Year Toggle
              Row(
                children: ['Week', 'Month', 'Year'].map((label) {
                  final isActive = selectedOverview == label;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedOverview = label),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF1A237E)
                                : Colors.grey.shade300,
                            width: 3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? const Color(0xFF1A237E)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Bar Chart
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChart(
                  BarChartData(
                    barGroups: getBarGroups(selectedMode),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2000,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value ~/ 1000}k',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
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
