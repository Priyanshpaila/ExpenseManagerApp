import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/expense_controller.dart';
import 'package:my_app_one/features/expense_manager/model/expense_model.dart';


final expenseProvider = StateNotifierProvider<ExpenseController, List<ExpenseModel>>(
  (ref) => ExpenseController(),
);
