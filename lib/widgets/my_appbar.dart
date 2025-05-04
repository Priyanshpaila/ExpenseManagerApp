// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/theme_provider.dart';

class MyAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const MyAppbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: SafeArea(
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🍔 Drawer Button
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Open menu',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),

                /// 🔠 Title (responsive font size)
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: screenWidth < 360 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                /// 🔘 Action Buttons + Theme Switch
                Row(
                  children: [
                    ...?actions,
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: 'Toggle Theme',
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder:
                            (child, animation) => RotationTransition(
                              turns: animation,
                              child: child,
                            ),
                        child: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          key: ValueKey<bool>(isDark),
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        final current = ref.read(themeModeProvider);
                        ref.read(themeModeProvider.notifier).state =
                            current == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}
