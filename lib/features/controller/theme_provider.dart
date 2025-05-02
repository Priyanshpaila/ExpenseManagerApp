import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🔘 Light / Dark / System toggle
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// 🎨 Primary Color Provider
final themeColorProvider =
    StateNotifierProvider<ThemeColorController, MaterialColor>(
      (ref) => ThemeColorController(),
    );

class ThemeColorController extends StateNotifier<MaterialColor> {
  ThemeColorController() : super(Colors.teal) {
    _loadColor();
  }

  /// Persist and apply selected color
  Future<void> setColor(MaterialColor color) async {
    state = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColorIndex', availableColors.indexOf(color));
  }

  /// Load saved color
  Future<void> _loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('themeColorIndex') ?? 0;
    state = availableColors[index.clamp(0, availableColors.length - 1)];
  }

  /// Available theme color options
  static List<MaterialColor> get availableColors => [
    Colors.teal,
    Colors.blue,
    Colors.deepPurple,
    Colors.orange,
    Colors.pink,
    Colors.green,
    Colors.indigo,
    Colors.red,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.lime,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.purple,
    Colors.yellow,
    Colors.grey,
    Colors.blueGrey,
  ];
}
