import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_planner/models/transaction_model.dart';
import 'package:budget_planner/services/hive_transaction_service.dart';
import 'package:intl/intl.dart';
import 'package:budget_planner/utils/user_utils.dart';

class MyChart extends StatefulWidget {
  final String selectedMode;
  final String selectedView;
  final DateTimeRange? selectedRange;

  const MyChart({
    super.key,
    required this.selectedMode,
    required this.selectedView,
    this.selectedRange,
  });

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  int touchedIndex = -1;
  double totalAmount = 0.0;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    await loadCurrentUser();
    final allTxns =
        HiveTransactionService.getAllTransactions();

    final start =
        widget.selectedRange?.start ?? DateTime(2020);
    final end = widget.selectedRange?.end ?? DateTime.now();

    final filtered = allTxns.where((txn) {
      final inRange =
          txn.date.isAfter(start) &&
          txn.date.isBefore(
            end.add(const Duration(days: 1)),
          );
      return txn.type == widget.selectedMode && inRange;
    }).toList();

    final sum = filtered.fold<double>(
      0.0,
      (previous, txn) => previous + txn.amount,
    );

    setState(() {
      _transactions = filtered;
      totalAmount = sum;
    });
  }

  String? get subtitle {
    final range = widget.selectedRange;
    if (range == null) return null;
    final formatter = (DateTime date) =>
        '${_monthName(date.month)} ${date.day}, ${date.year}';
    if (range.start.month == range.end.month &&
        range.start.year == range.end.year) {
      return '${_monthName(range.start.month)} ${range.start.year}';
    }
    return '${formatter(range.start)} - ${formatter(range.end)}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  /// 🔹 Group transactions dynamically based on view (Daily / Weekly / Monthly)
  List<double> _generateData() {
    if (_transactions.isEmpty) return [];

    if (widget.selectedView == 'Daily') {
      final Map<String, double> grouped = {};
      for (final txn in _transactions) {
        final day = DateFormat('EEE').format(txn.date);
        grouped[day] = (grouped[day] ?? 0) + txn.amount;
      }
      final weekDays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];
      return weekDays
          .map((d) => (grouped[d] ?? 0) / 1000)
          .toList();
    } else if (widget.selectedView == 'Weekly') {
      final Map<int, double> grouped = {};
      for (final txn in _transactions) {
        final weekNum = int.parse(
          DateFormat('w').format(txn.date),
        ); // ISO week number
        grouped[weekNum] =
            (grouped[weekNum] ?? 0) + txn.amount;
      }
      final weeks = grouped.keys.toList()..sort();
      return weeks
          .map((w) => (grouped[w]! / 1000))
          .toList();
    } else {
      // Monthly
      final Map<String, double> grouped = {};
      for (final txn in _transactions) {
        final month = DateFormat('MMM').format(txn.date);
        grouped[month] = (grouped[month] ?? 0) + txn.amount;
      }
      final months = grouped.keys.toList()..sort();
      return months
          .map((m) => (grouped[m]! / 1000))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateData();

    return Column(
      children: [
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        const SizedBox(height: 5),
        Text(
          widget.selectedMode == 'Income'
              ? '£${totalAmount.toStringAsFixed(2)}'
              : '-£${totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: widget.selectedMode == 'Income'
                ? Colors.green
                : Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(child: BarChart(mainBarData(data))),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    bool isTouched = x == touchedIndex;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 14,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y + 1,
            color: Colors.grey[300],
          ),
          color: Colors.transparent,
          rodStackItems: [
            BarChartRodStackItem(
              0,
              y,
              isTouched
                  ? (widget.selectedMode == 'Income'
                        ? Colors.green
                        : Colors.red)
                  : Colors.black,
            ),
          ],
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }

  BarChartData mainBarData(List<double> data) {
    final barGroups = List.generate(
      data.length,
      (index) => makeGroupData(index, data[index]),
    );

    double maxY = 5;
    if (barGroups.isNotEmpty) {
      final highest = barGroups
          .map((group) => group.barRods.first.toY)
          .reduce((a, b) => a > b ? a : b);
      maxY = (highest.ceil() + 1).toDouble();
    }

    return BarChartData(
      maxY: maxY,
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: (value, meta) =>
                getLeftTitles(value, meta, maxY),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      barGroups: barGroups,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.black87,
          getTooltipItem:
              (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '£${(rod.toY * 1000).toStringAsFixed(0)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
        ),
        touchCallback: (event, response) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex =
                response.spot!.touchedBarGroupIndex;
          });
        },
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    );
    final dayLabels = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];
    final weekLabels = [
      'W1',
      'W2',
      'W3',
      'W4',
      'W5',
      'W6',
      'W7',
    ];

    final monthLabels = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    List<String> labels;
    if (widget.selectedView == 'Weekly') {
      labels = weekLabels;
    } else if (widget.selectedView == 'Monthly') {
      labels = monthLabels.take(7).toList();
    } else {
      labels = dayLabels;
    }

    if (value.toInt() < 0 ||
        value.toInt() >= labels.length) {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7,
      child: Text(labels[value.toInt()], style: style),
    );
  }

  Widget getLeftTitles(
    double value,
    TitleMeta meta,
    double maxY,
  ) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    if (value % 1 == 0 && value <= maxY) {
      return SideTitleWidget(
        space: 0,
        axisSide: meta.axisSide,
        child: Text('${value.toInt()}k', style: style),
      );
    }

    return Container();
  }
}
