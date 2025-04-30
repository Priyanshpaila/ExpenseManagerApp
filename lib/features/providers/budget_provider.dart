import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/budget_controller.dart';

final budgetProvider = StateNotifierProvider<BudgetController, double>(
  (ref) => BudgetController(),
);
