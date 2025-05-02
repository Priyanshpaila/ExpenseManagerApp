import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/filtered_expense_provider.dart';
import 'package:my_app_one/features/providers/budget_provider.dart';
import 'package:my_app_one/features/widgets/charts_widget.dart';
import 'package:my_app_one/features/widgets/expense_list.dart';
import 'package:my_app_one/widgets/drawer_widget.dart';
import 'package:my_app_one/widgets/footer_widget.dart';
import 'package:my_app_one/widgets/my_appbar.dart';
import 'package:printing/printing.dart';
import 'package:my_app_one/core/utils/pdf_generator.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedMonthProvider.notifier).state = selectedMonth;
      ref.read(selectedYearProvider.notifier).state = selectedYear;
      ref.read(selectedCategoryProvider.notifier).state = selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final expenses = ref.watch(filteredExpenseProvider);

    final bgColor = isDark ? Colors.black : Colors.white;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const DrawerWidget(),
      appBar: MyAppbar(
        title: 'History',
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export History',
            onPressed: () async {
              final pdf = await generateExpensePdf(
                expenses: expenses,
                budget: ref.read(budgetProvider),
                month: selectedMonth,
                year: selectedYear,
              );
              await Printing.layoutPdf(onLayout: (format) async => pdf);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          /// 📅 Filter Card
          Card(
            elevation: 5,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Select Month & Year',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedMonth,
                          items: List.generate(12, (i) => i + 1).map((month) {
                            return DropdownMenuItem(
                              value: month,
                              child: Text(monthName(month)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedMonth = val;
                                ref.read(selectedMonthProvider.notifier).state = val;
                              });
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Month'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedYear,
                          items: List.generate(5, (i) => DateTime.now().year - i).map((year) {
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedYear = val;
                                ref.read(selectedYearProvider.notifier).state = val;
                              });
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Year'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    value: selectedCategory,
                    icon: const Icon(Icons.expand_more),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Categories')),
                      DropdownMenuItem(value: 'Food', child: Text('Food')),
                      DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                      DropdownMenuItem(value: 'Rent', child: Text('Rent')),
                      DropdownMenuItem(value: 'Bills', child: Text('Bills')),
                      DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                      DropdownMenuItem(value: 'Others', child: Text('Others')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                        ref.read(selectedCategoryProvider.notifier).state = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 📈 Charts Section
          Row(
            children: const [
              Icon(Icons.bar_chart_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Spending Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 5,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ChartsWidget(),
            ),
          ),

          const SizedBox(height: 20),

          /// 💳 Expense List Section
          Row(
            children: const [
              Icon(Icons.receipt_long_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Expense History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 5,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ExpenseList(expenses: expenses),
            ),
          ),

          const SizedBox(height: 24),
          const FooterWidget(),
        ],
      ),
    );
  }

  String monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
