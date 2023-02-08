import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Persist the user's preferred ThemeMode to local storage
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('theme', theme.toString());
  }

  /// Loads the User's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    // Load the user's preferred ThemeMode from local storage
    final preferences = await SharedPreferences.getInstance();
    final theme = preferences.getString('theme');

    // If the user has not set a preferred ThemeMode, return the system default.
    if (theme == null) return ThemeMode.system;

    // Otherwise, return the user's preferred ThemeMode.
    return ThemeMode.values.firstWhere((e) => e.toString() == theme);
  }

  Future<void> updateAutoStartFocus(bool autoStartFocus) async {
    // Persist the user's preferred auto start focus mode to local storage
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('autoStartFocus', autoStartFocus);
  }

  Future<bool> autoStartFocus() async {
    // Load the user's preferred auto start focus from local storage
    final preferences = await SharedPreferences.getInstance();
    final autoStartFocus = preferences.getBool('autoStartFocus');

    // If the user has not set a preferred auto start focus, return the system default.
    if (autoStartFocus == null) return false;

    // Otherwise, return the user's preferred auto start focus.
    return autoStartFocus;
  }

  Future<void> updateNotificationAudio(String notificationAudio) async {
    // Persist the user's preferred notification audio to local storage
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('notificationAudio', notificationAudio);
  }

  Future<String> notificationAudio() async {
    // Load the user's preferred notification audio from local storage
    final preferences = await SharedPreferences.getInstance();
    final notificationAudio = preferences.getString('notificationAudio');

    // If the user has not set a preferred notification audio, return the system default.
    if (notificationAudio == null) {
      return 'ill-make-it-possible-notification.wav';
    }

    // Otherwise, return the user's preferred notification audio.
    return notificationAudio;
  }

  Future<void> updateNotificationAfterFocusGoal(
      bool notificationForEachFocusGoal) async {
    // Persist the user's preferred notification for each focus goal to local storage
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'notificationForEachFocusGoal', notificationForEachFocusGoal);
  }

  Future<bool> notificationAfterFocusGoal() async {
    // Load the user's preferred notification for each focus goal from local storage
    final preferences = await SharedPreferences.getInstance();
    final notificationForEachFocusGoal =
        preferences.getBool('notificationForEachFocusGoal');

    // If the user has not set a preferred notification for each focus goal, return the system default.
    if (notificationForEachFocusGoal == null) return false;

    // Otherwise, return the user's preferred notification for each focus goal.
    return notificationForEachFocusGoal;
  }
}
