import 'dart:async';

import 'package:astro_flow/controllers/settings_controller.dart';
import 'package:astro_flow/models/timer_model.dart';
import 'package:astro_flow/screens/settings_view.dart';
import 'package:astro_flow/services/local_notice_service.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

class TimerView extends StatelessWidget {
  const TimerView({super.key, required this.controller});
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsView.routeName);
                  },
                  icon: const Icon(Icons.settings_rounded),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [StopwatchControl(controller: controller)],
          ),
        ],
      ),
    );
  }
}

// the timer view
class StopwatchControl extends StatefulWidget {
  const StopwatchControl({super.key, required this.controller});

  final SettingsController controller;

  @override
  State<StopwatchControl> createState() => _StopwatchControlState();
}

class _StopwatchControlState extends State<StopwatchControl> {
  // Initialize the local notification service.
  late final LocalNotificationService notificationService;

  // Initialize the Timer model.
  TimerModel timerModel = TimerModel();

  late Stopwatch _stopwatch;
  late Timer _timer;
  @override
  void initState() {
    notificationService = LocalNotificationService();
    notificationService.initialize();
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        // If the stopwatch is on break, decrease the break time by 30ms.
        // Also, the break time should never be less than 0.
        if (timerModel.onBreak) {
          // If the break time is 0, send a notification.
          if (timerModel.timeRemaining == 0 &&
              !timerModel.breakFinishedNotificationSent) {
            timerModel.breakFinishedNotificationSent = true;
            notificationService.showNotification(
              id: 0,
              title: 'Astro Flow',
              body: 'Hey... Hey! Snap out of it! Time to focus.',
              sound: 'break-finished.wav',
            );
            // Start the focus timer if the user has auto start focus enabled.
            if (widget.controller.autoStartFocus) {
              timerModel.onBreak = false;
              timerModel.timeRemaining = 0;
            }
          }
          timerModel.timeRemaining =
              (timerModel.timeRemaining - 30).clamp(0, timerModel.breakTime);
        } else if (!timerModel.onBreak && _stopwatch.isRunning) {
          // If the stopwatch is not on break, increase the work time by 30ms.
          timerModel.workTime = _stopwatch.elapsedMilliseconds;
          timerModel.breakTime = calculateBreakTime(timerModel.workTime);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {}); // re-render the page
  }

  int calculateBreakTime(int milliseconds) {
    // Convert milliseconds to minutes.
    var minutes = milliseconds ~/ 60000;
    // If the minutes are less than 5, return 2 minutes.
    // If the minutes are 5-25, return 5 minutes.
    // If the minutes are 25-50, return 10 minutes.
    // Otherwise, return 15 minutes.
    // This needs to return milliseconds.

    if (minutes < 2) {
      // If it's less than 2 minutes, return 0 and don't send a notification.
      return 0;
    }

    if (minutes < 5) {
      return 2 * 60000;
    } else if (minutes < 25) {
      return 5 * 60000;
    } else if (minutes < 50) {
      return 10 * 60000;
    } else {
      return 15 * 60000;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          timerModel.onBreak
              ? 'Spacing Out'
              : _stopwatch.isRunning
                  ? 'Focusing'
                  : 'Ready to Focus?',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 5),
        Text(
          formatTime(timerModel.onBreak
              ? timerModel.timeRemaining
              : timerModel.workTime),
          style: const TextStyle(fontSize: 48.0),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 125,
          height: 75,
          child: Container(
            // rounded corners
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 151, 104, 251),
                  Color.fromARGB(255, 245, 41, 214),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: handleStartStop,
                  icon: Icon(_stopwatch.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    // await player.setSource(AssetSource('sounds/starting-break.wav'));
                    setState(() {
                      timerModel.onBreak = !timerModel.onBreak;
                      // If the stopwatch is on break, set the break time.
                      if (timerModel.onBreak) {
                        var breakTime =
                            calculateBreakTime(_stopwatch.elapsedMilliseconds);
                        timerModel.timeRemaining = breakTime;
                        timerModel.breakTime = breakTime;
                        timerModel.breakFinishedNotificationSent = false;

                        // Send a notification when starting a break.
                        if (timerModel.breakTime > 0) {
                          // Send a notification.
                          notificationService.showNotification(
                            id: 1,
                            title: 'Astro Flow',
                            body: 'Time to space out for a bit.',
                            sound: 'positive.wav',
                          );
                        }
                      } else {
                        // If the stopwatch is not on break, reset the work time.
                        timerModel.workTime = 0;
                      }
                      _stopwatch.reset();
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          // If not on break, show the amount of time earned.
          timerModel.onBreak
              ? ''
              : 'Space Out Time: ${formatTime(timerModel.breakTime)}',
          style: const TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}
