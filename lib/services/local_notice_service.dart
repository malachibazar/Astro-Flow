import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    LinuxInitializationSettings initializationSettingsLinux =
        const LinuxInitializationSettings(
      defaultActionName: 'Get notified, fool!',
      defaultSuppressSound: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      linux: initializationSettingsLinux,
    );

    await _localNotificationService.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _getNotificationDetails({String? sound}) async {
    LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      defaultActionName: '',
      timeout: const LinuxNotificationTimeout(5),
      // If sound is not null, then set the sound with the given name
      sound: sound != null ? AssetsLinuxSound('assets/sounds/$sound') : null,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );

    return platformChannelSpecifics;
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      String? sound}) async {
    final NotificationDetails notificationDetails =
        await _getNotificationDetails(sound: sound);

    await _localNotificationService.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void onSelectNotification(String? payload) {
    // print(payload);
  }
}
