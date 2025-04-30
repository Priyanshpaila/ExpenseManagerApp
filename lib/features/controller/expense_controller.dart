import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/expense_manager/model/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseController extends StateNotifier<List<ExpenseModel>> {
  ExpenseController() : super([]) {
    _loadExpenses(); // Load when the app starts
  }

  Future<void> addExpense(ExpenseModel expense) async {
    state = [...state, expense];
    await _saveExpenses();
  }

  Future<void> deleteExpense(String id) async {
    state = state.where((expense) => expense.id != id).toList();
    await _saveExpenses();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseList = state.map((e) => e.toJson()).toList();
    await prefs.setString('expenses', jsonEncode(expenseList));
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expenses');
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      state = decoded.map((e) => ExpenseModel.fromJson(e)).toList();
    }
  }
}
