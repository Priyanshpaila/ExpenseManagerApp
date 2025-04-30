import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/expense_manager/model/expense_model.dart';
import 'package:my_app_one/features/providers/expense_provider.dart';

final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);
final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedCategoryProvider = StateProvider<String?>(
  (ref) => null,
); // New: null = All

final filteredExpenseProvider = Provider<List<ExpenseModel>>((ref) {
  final allExpenses = ref.watch(expenseProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  final selectedYear = ref.watch(selectedYearProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return allExpenses.where((expense) {
    final matchesDate =
        expense.date.month == selectedMonth &&
        expense.date.year == selectedYear;
    final matchesCategory =
        selectedCategory == null || expense.category == selectedCategory;
    return matchesDate && matchesCategory;
  }).toList();
});
