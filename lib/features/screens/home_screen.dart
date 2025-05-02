import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/core/utils/pdf_generator.dart';
import 'package:my_app_one/features/controller/filtered_expense_provider.dart';
import 'package:my_app_one/features/controller/user_profile_controller.dart';
import 'package:my_app_one/features/providers/budget_provider.dart';
import 'package:my_app_one/features/screens/history_screen.dart';
import 'package:my_app_one/features/widgets/add_expenseform.dart';
import 'package:my_app_one/features/widgets/charts_widget.dart';
import 'package:my_app_one/widgets/footer_widget.dart';
import 'package:my_app_one/widgets/my_appbar.dart';
import 'package:my_app_one/features/widgets/expense_list.dart';
import 'package:my_app_one/features/widgets/budget_status_card.dart';
import 'package:printing/printing.dart';
import 'package:my_app_one/widgets/drawer_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(filteredExpenseProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final profile = ref.watch(userProfileProvider);

    final theme = Theme.of(context);
    final greeting = _getTimeBasedGreeting(profile.name);

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: MyAppbar(
        title: 'Expense Manager',
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export as PDF',
            onPressed: () async {
              final pdfData = await generateExpensePdf(
                expenses: ref.read(filteredExpenseProvider),
                budget: ref.read(budgetProvider),
                month: ref.read(selectedMonthProvider),
                year: ref.read(selectedYearProvider),
              );
              await Printing.layoutPdf(onLayout: (format) async => pdfData);
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          radius: const Radius.circular(10),
          thickness: 6,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80, top: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  greeting,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BudgetStatusCard(),
              ),
              const SizedBox(height: 16),
              _buildFilterCard(selectedMonth, selectedYear, selectedCategory),
              const SizedBox(height: 12),
              _buildChartSection(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ExpenseList(expenses: expenses),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AddExpenseForm(),
              ),
              const SizedBox(height: 24),
              const FooterWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSetBudgetDialog(context, ref),
        label: const Text(
          'Set Budget',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.edit, size: 20),
        elevation: 6,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  String _getTimeBasedGreeting(String name) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else if (hour < 20) {
      greeting = "Good Evening";
    } else {
      greeting = "Good Night";
    }

    final emoji =
        hour < 12
            ? "🌤️"
            : hour < 17
            ? "☀️"
            : hour < 20
            ? "🌇"
            : "🌙";

    return "$greeting, ${name.isNotEmpty ? name : "there"} $emoji";
  }

  Widget _buildFilterCard(
    int selectedMonth,
    int selectedYear,
    String? selectedCategory,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Filter Expenses",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      icon: const Icon(Icons.expand_more_rounded),
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'Month',
                        prefixIcon: const Icon(Icons.calendar_today_rounded),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items:
                          List.generate(12, (i) => i + 1)
                              .map(
                                (month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(monthName(month)),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(selectedMonthProvider.notifier).state = val;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      icon: const Icon(Icons.expand_more_rounded),
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        prefixIcon: const Icon(Icons.event_rounded),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items:
                          List.generate(5, (i) => DateTime.now().year - i)
                              .map(
                                (year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(selectedYearProvider.notifier).state = val;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                value: selectedCategory,
                icon: const Icon(Icons.expand_more),
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Categories')),
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(
                    value: 'Transport',
                    child: Text('Transport'),
                  ),
                  DropdownMenuItem(value: 'Rent', child: Text('Rent')),
                  DropdownMenuItem(value: 'Bills', child: Text('Bills')),
                  DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (val) {
                  ref.read(selectedCategoryProvider.notifier).state = val;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: ChartsWidget(),
        ),
      ),
    );
  }

  String monthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  void _showSetBudgetDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: const [
                Icon(Icons.account_balance_wallet_rounded, color: Colors.teal),
                SizedBox(width: 8),
                Text("Set Monthly Budget"),
              ],
            ),
            content: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter amount in ₹',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(controller.text);
                  if (amount != null && amount > 0) {
                    ref.read(budgetProvider.notifier).setBudget(amount);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Budget set to ₹${amount.toStringAsFixed(2)}",
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}
