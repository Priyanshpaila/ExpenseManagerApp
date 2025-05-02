import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/theme_provider.dart';
import 'package:my_app_one/features/screens/about_screen.dart';
import 'package:my_app_one/features/screens/profile_screen.dart';
import 'package:my_app_one/features/screens/splash_screen.dart';
import 'package:my_app_one/features/screens/home_screen.dart';
import 'package:my_app_one/features/screens/history_screen.dart';
import 'package:my_app_one/features/screens/settings_screen.dart'; // if created

void main() {
  runApp(const ProviderScope(child: ExpenseManagerApp()));
}

class ExpenseManagerApp extends ConsumerWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final primaryColor = ref.watch(themeColorProvider);

    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // ✅ Define Named Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/about': (context) => const AboutScreen(), // if you create it
      },
    );
  }
}
