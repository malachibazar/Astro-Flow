// The preferences model is a simple class that stores the user's preferences.
import 'package:flutter/material.dart';

class PreferencesModel {
  // The user's preferred theme.
  ThemeMode themeMode;

  // Auto start focus timer when break ends.
  bool autoStartFocus;

  // Constructor
  PreferencesModel({
    this.themeMode = ThemeMode.system,
    this.autoStartFocus = false,
  });
}
