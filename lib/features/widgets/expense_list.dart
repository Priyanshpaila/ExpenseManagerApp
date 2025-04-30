// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/expense_manager/model/expense_model.dart';
import '../providers/expense_provider.dart';

class ExpenseList extends ConsumerWidget {
  final List<ExpenseModel> expenses;

  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No expenses yet!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      shrinkWrap: true, // ✅ important for nested scrolling
      physics:
          const NeverScrollableScrollPhysics(), // ✅ disable internal scroll
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                elevation: 6,
                shadowColor: Colors.teal.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.teal.withOpacity(0.1),
                  onTap: () {
                    // Optional: expand details or animate
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🌈 Gradient Avatar Icon
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade400,
                                Colors.teal.shade800,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.api_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// 🟡 Description + Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                expense.category,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 🔴 Amount + Delete
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${expense.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder:
                                      (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        titlePadding: const EdgeInsets.fromLTRB(
                                          24,
                                          24,
                                          24,
                                          12,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                        actionsPadding:
                                            const EdgeInsets.fromLTRB(
                                              16,
                                              8,
                                              16,
                                              16,
                                            ),
                                        title: Row(
                                          children: const [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "Delete Expense",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          "Are you sure you want to delete this expense? This action cannot be undone.",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        actions: [
                                          OutlinedButton.icon(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                            ),
                                            label: const Text("Cancel"),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                              side: BorderSide(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).dividerColor,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ref
                                                  .read(
                                                    expenseProvider.notifier,
                                                  )
                                                  .deleteExpense(expense.id);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 16,
                                                      ),
                                                  backgroundColor:
                                                      Colors.redAccent.shade100,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          'Expense deleted successfully!',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                            label: const Text("Delete"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              tooltip: 'Delete',
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
