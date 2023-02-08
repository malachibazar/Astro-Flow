import 'package:astro_flow/models/settings_model.dart';
import 'package:astro_flow/services/local_notice_service.dart';
import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});
  final SettingsController controller;
  static const routeName = '/settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Initialize the local notification service.
  late final LocalNotificationService notificationService;

  @override
  void initState() {
    notificationService = LocalNotificationService();
    notificationService.initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: widget.controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: widget.controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Auto start work after break',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Switch(
              // Read the autoStartFocus value from the controller
              value: widget.controller.autoStartFocus,
              // Call the updateAutoStartFocus method any time the user toggles the switch.
              onChanged: widget.controller.updateAutoStartFocus,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Send notification after reaching a focus session goal',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Switch(
              // Read the autoStartFocus value from the controller
              value: widget.controller.notificationAfterFocusGoal,
              // Call the updateAutoStartFocus method any time the user toggles the switch.
              onChanged: widget.controller.updateNotificationAfterFocusGoal,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Notification Audio',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButton<String>(
              // Read the selected notificationAudio from the controller
              value: widget.controller.notificationAudio,
              // Call the updateNotificationAudio method any time the user selects a theme.
              onChanged: (value) {
                widget.controller.updateNotificationAudio(value);
                notificationService.showNotification(
                  id: 0,
                  title: 'Astro Flow',
                  body: 'Test notification',
                  sound:
                      notificationAudioMap[widget.controller.notificationAudio],
                );
              },
              items: [
                for (final audio in notificationAudioMap.keys)
                  DropdownMenuItem(
                    value: audio,
                    child: Text(audio),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
