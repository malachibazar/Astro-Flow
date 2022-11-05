import 'package:flutter/material.dart';

import '../services/settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Make autoStartFocus a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late bool _autoStartFocus;

  // Make notificationAudio a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late String _notificationAudio;

  // Make notificationAfterFocusGoal a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late bool _notificationAfterFocusGoal;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  // Allow Widgets to read the user's preferred autoStartFocus.
  bool get autoStartFocus => _autoStartFocus;

  // Allow Widgets to read the user's preferred notificationAudio.
  String get notificationAudio => _notificationAudio;

  // Allow Widgets to read the user's preferred notification after focus goal.
  bool get notificationAfterFocusGoal => _notificationAfterFocusGoal;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _autoStartFocus = await _settingsService.autoStartFocus();
    _notificationAudio = await _settingsService.notificationAudio();
    _notificationAfterFocusGoal =
        await _settingsService.notificationAfterFocusGoal();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the autoStartFocus based on the user's selection.
  Future<void> updateAutoStartFocus(bool? newAutoStartFocus) async {
    if (newAutoStartFocus == null) return;

    // Do not perform any work if new and old autoStartFocus are identical
    if (newAutoStartFocus == _autoStartFocus) return;

    // Otherwise, store the new autoStartFocus in memory
    _autoStartFocus = newAutoStartFocus;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateAutoStartFocus(newAutoStartFocus);
  }

  /// Update and persist the notificationAudio based on the user's selection.
  Future<void> updateNotificationAudio(String? newNotificationAudio) async {
    if (newNotificationAudio == null) return;

    // Do not perform any work if new and old notificationAudio are identical
    if (newNotificationAudio == _notificationAudio) return;

    // Otherwise, store the new notificationAudio in memory
    _notificationAudio = newNotificationAudio;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateNotificationAudio(newNotificationAudio);
  }

  /// Update and persist the notificationAfterFocusGoal based on the user's selection.
  Future<void> updateNotificationAfterFocusGoal(
      bool? newNotificationAfterFocusGoal) async {
    if (newNotificationAfterFocusGoal == null) return;

    // Do not perform any work if new and old notificationAfterFocusGoal are identical
    if (newNotificationAfterFocusGoal == _notificationAfterFocusGoal) return;

    // Otherwise, store the new notificationAfterFocusGoal in memory
    _notificationAfterFocusGoal = newNotificationAfterFocusGoal;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService
        .updateNotificationAfterFocusGoal(newNotificationAfterFocusGoal);
  }
}
