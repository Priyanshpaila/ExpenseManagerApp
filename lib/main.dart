import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/theme_provider.dart';
import 'package:my_app_one/features/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: ExpenseManagerApp()));
}

class ExpenseManagerApp extends ConsumerWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode, // 🔥 Dynamic
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // 👇 Start with SplashScreen
      home: const SplashScreen(),
    );
  }
}
