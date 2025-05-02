// features/controller/user_profile_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileController, UserProfile>(
  (ref) => UserProfileController(),
);

class UserProfile {
  final String name;
  final String about;

  const UserProfile({this.name = 'Priyansh', this.about = 'Expense Enthusiast'});

  UserProfile copyWith({String? name, String? about}) {
    return UserProfile(
      name: name ?? this.name,
      about: about ?? this.about,
    );
  }
}

class UserProfileController extends StateNotifier<UserProfile> {
  UserProfileController() : super(const UserProfile()) {
    _loadProfile();
  }

  Future<void> updateProfile(String name, String about) async {
    state = UserProfile(name: name, about: about);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_about', about);
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? 'Priyansh';
    final about = prefs.getString('profile_about') ?? 'Expense Enthusiast';
    state = UserProfile(name: name, about: about);
  }
}
