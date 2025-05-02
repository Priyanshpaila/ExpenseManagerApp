// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';

class ChartsWidget extends ConsumerWidget {
  const ChartsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    final dailyTotals = <String, double>{};
    for (final e in expenses) {
      final day = '${e.date.day}/${e.date.month}';
      dailyTotals[day] = (dailyTotals[day] ?? 0) + e.amount;
    }

    final categoryTotals = <String, double>{};
    for (final e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    final hasData = dailyTotals.isNotEmpty || categoryTotals.isNotEmpty;

    return hasData
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "📊 Daily Expense (Bar Chart)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY:
                      dailyTotals.values.fold(
                        0.0,
                        (max, e) => e > max ? e : max,
                      ) +
                      30,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= dailyTotals.length) {
                            return const SizedBox.shrink();
                          }

                          final label = dailyTotals.keys.elementAt(
                            value.toInt(),
                          );
                          final shouldShow =
                              dailyTotals.length <= 6 || value.toInt().isEven;

                          return shouldShow
                              ? Transform.rotate(
                                angle: -0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    label,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups:
                      dailyTotals.entries
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.value,
                                  width: 12,
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.teal.shade400,
                                      Colors.teal.shade900,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY:
                                        dailyTotals.values.fold(
                                          0.0,
                                          (max, e) => e > max ? e : max,
                                        ) +
                                        20,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.teal.shade100,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (dailyTotals.isEmpty ||
                            group.x.toInt() >= dailyTotals.length) {
                          return null;
                        }
                        final day = dailyTotals.keys.elementAt(group.x.toInt());
                        return BarTooltipItem(
                          '$day\n₹${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
              ),
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "🧾 Category Breakdown (Pie Chart)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 240,
              child: PieChart(
                PieChartData(
                  startDegreeOffset: 180,
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections:
                      categoryTotals.entries.map((entry) {
                        final total = categoryTotals.values.fold(
                          0.0,
                          (sum, e) => sum + e,
                        );
                        final color =
                            Colors.primaries[entry.key.hashCode %
                                Colors.primaries.length];

                        return PieChartSectionData(
                          value: entry.value,
                          color: color,
                          radius: 60,
                          title:
                              '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      // Optional: add interaction logic
                    },
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children:
                    categoryTotals.entries.map((entry) {
                      final icon = _getCategoryIcon(entry.key);
                      final color =
                          Colors.primaries[entry.key.hashCode %
                              Colors.primaries.length];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: color, size: 18),
                          const SizedBox(width: 4),
                          Text(entry.key, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        )
        : const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              "No chart data available.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'rent':
        return Icons.home;
      case 'bills':
        return Icons.receipt_long;
      case 'shopping':
        return Icons.shopping_bag;
      case 'others':
      default:
        return Icons.category;
    }
  }
}
