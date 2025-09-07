import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatefulWidget {
  final double totalAmount;
  final String selectedMode;
  final String selectedView;
  final DateTimeRange? selectedRange;

  const MyChart({
    super.key,
    this.totalAmount = 3500.0,
    required this.selectedMode,
    required this.selectedView,
    this.selectedRange,
  });

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  int touchedIndex = -1;

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

  List<String> _generateMonthLabelsFromRange() {
    final range = widget.selectedRange;
    if (range == null) {
      return [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
      ];
    }

    final months = <String>[];
    DateTime current = DateTime(
      range.start.year,
      range.start.month,
    );

    while (current.isBefore(range.end) ||
        (current.month == range.end.month &&
            current.year == range.end.year)) {
      months.add(_monthName(current.month).toUpperCase());
      current = DateTime(current.year, current.month + 1);
    }

    return months;
  }

  @override
  Widget build(BuildContext context) {
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
              ? '£${widget.totalAmount.toStringAsFixed(2)}'
              : '-£${widget.totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: widget.selectedMode == 'Income'
                ? Colors.green
                : Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(child: BarChart(mainBarData())),
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

  List<BarChartGroupData> showingBarGroups() {
    List<double> data = [];
    int count = 7;

    if (widget.selectedView == 'Daily') {
      data = widget.selectedMode == 'Income'
          ? [2.0, 2.5, 1.8, 2.2, 1.9, 2.3, 2.0]
          : [1.2, 1.5, 1.3, 1.6, 1.8, 1.1, 1.7];
    } else if (widget.selectedView == 'Weekly') {
      data = widget.selectedMode == 'Income'
          ? [3.5, 4.0, 3.8, 4.2, 3.6, 3.9, 4.1]
          : [2.5, 3.0, 2.8, 3.1, 2.9, 2.7, 3.2];
    } else if (widget.selectedView == 'Monthly') {
      final monthLabels = _generateMonthLabelsFromRange();
      count = monthLabels.length.clamp(0, 7);
      data = List.generate(
        count,
        (i) => widget.selectedMode == 'Income'
            ? 7.0 + i.toDouble()
            : 2.0 + i.toDouble(),
      );
    }

    return List.generate(data.length, (index) {
      return makeGroupData(index, data[index]);
    });
  }

  BarChartData mainBarData() {
    final barGroups = showingBarGroups();

    // Compute maxY dynamically
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
    final monthLabels = _generateMonthLabelsFromRange();

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
