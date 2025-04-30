import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetController extends StateNotifier<double> {
  BudgetController() : super(0.0) {
    _loadBudget();
  }

  Future<void> setBudget(double budget) async {
    state = budget;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget', budget);
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final budget = prefs.getDouble('budget');
    if (budget != null) {
      state = budget;
    }
  }
}
