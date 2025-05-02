import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_app_one/features/providers/budget_provider.dart';

import '../providers/expense_provider.dart';

class BudgetStatusCard extends ConsumerWidget {
  const BudgetStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    final budget = ref.watch(budgetProvider);
    final theme = Theme.of(context);
    final totalSpent = expenses.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final remaining = budget - totalSpent;
    final spentRatio = budget > 0 ? (totalSpent / budget).clamp(0, 1) : 0;

    String message;
    Color messageColor;
    IconData messageIcon;

    if (budget == 0) {
      message = "No budget set!";
      messageColor = Colors.grey;
      messageIcon = Icons.info_outline;
    } else if (remaining < 0) {
      message = "Over Budget! 😟";
      messageColor = Colors.red;
      messageIcon = Icons.warning_amber_rounded;
    } else if (remaining < budget * 0.2) {
      message = "Careful, almost done! ⚡";
      messageColor = Colors.orange;
      messageIcon = Icons.error_outline;
    } else {
      message = "You're doing great! 🎉";
      messageColor = Colors.green;
      messageIcon = Icons.check_circle_outline;
    }

    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧾 Header Row with Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Budget Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    ref.read(budgetProvider.notifier).resetBudget();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Budget reset to ₹0"),
                        backgroundColor: Colors.orange.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.red),
                  label: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 💰 Budget and Spent Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labelAndAmount("Budget", formatter.format(budget), context),
                _labelAndAmount("Spent", formatter.format(totalSpent), context),
              ],
            ),

            const SizedBox(height: 16),

            /// 📊 Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: spentRatio.toDouble(),
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  spentRatio >= 1
                      ? Colors.red
                      : spentRatio >= 0.8
                      ? Colors.orange
                      : Colors.teal,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🎯 Status Message
            Row(
              children: [
                Icon(messageIcon, color: messageColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: messageColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelAndAmount(String label, String amount, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
