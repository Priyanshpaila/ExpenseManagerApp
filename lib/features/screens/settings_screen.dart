import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app_one/features/controller/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedTheme = ref.watch(themeModeProvider);
    final selectedColor = ref.watch(themeColorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance Settings'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// 🎨 Theme Mode Section
          Column(
            children: [
              Text(
                "Theme Mode",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildThemeTile(
                context,
                title: "Light Mode",
                icon: Icons.light_mode_rounded,
                value: ThemeMode.light,
                groupValue: selectedTheme,
                onChanged:
                    (val) => ref.read(themeModeProvider.notifier).state = val!,
              ),
              _buildThemeTile(
                context,
                title: "Dark Mode",
                icon: Icons.dark_mode_rounded,
                value: ThemeMode.dark,
                groupValue: selectedTheme,
                onChanged:
                    (val) => ref.read(themeModeProvider.notifier).state = val!,
              ),
              _buildThemeTile(
                context,
                title: "System Default",
                icon: Icons.brightness_4_rounded,
                value: ThemeMode.system,
                groupValue: selectedTheme,
                onChanged:
                    (val) => ref.read(themeModeProvider.notifier).state = val!,
              ),
            ],
          ),

          const Divider(height: 40),

          /// 🌈 Color Picker Section
          Column(
            children: [
              Text(
                "Primary Accent Color",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children:
                    ThemeColorController.availableColors.map((color) {
                      final isSelected = selectedColor == color;

                      return InkWell(
                        onTap:
                            () => ref
                                .read(themeColorProvider.notifier)
                                .setColor(color),
                        customBorder: const CircleBorder(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 22,
                                  )
                                  : null,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border:
            isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 1.6)
                : Border.all(color: Colors.grey.shade300),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Icon(
          icon,
          color: isSelected ? theme.colorScheme.primary : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
        ),
        trailing: Radio<ThemeMode>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        onTap: () => onChanged(value),
      ),
    );
  }
}
