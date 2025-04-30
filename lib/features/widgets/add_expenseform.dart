import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:my_app_one/features/expense_manager/model/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  const AddExpenseForm({super.key});

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Food', 'icon': Icons.restaurant},
    {'label': 'Transport', 'icon': Icons.directions_car},
    {'label': 'Rent', 'icon': Icons.home},
    {'label': 'Bills', 'icon': Icons.receipt},
    {'label': 'Shopping', 'icon': Icons.shopping_bag},
    {'label': 'Others', 'icon': Icons.category},
  ];

  String _selectedCategory = 'Food';

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = ExpenseModel(
        id: const Uuid().v4(),
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim(),
        date: DateTime.now(),
        category: _selectedCategory,
      );

      ref.read(expenseProvider.notifier).addExpense(newExpense);

      _amountController.clear();
      _descriptionController.clear();
      setState(() => _selectedCategory = 'Food');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Expense added successfully!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: theme.primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Expense',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// 💰 Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter an amount';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0)
                    return 'Enter a valid amount';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              /// 📝 Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.edit_note),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Please enter a description';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              /// 📂 Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['label'],
                        child: Row(
                          children: [
                            Icon(category['icon'], size: 20),
                            const SizedBox(width: 8),
                            Text(category['label']),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),

              const SizedBox(height: 20),

              /// ➕ Add Expense Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addExpense,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(
                    "Add Expense",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
