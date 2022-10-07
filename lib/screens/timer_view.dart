import 'dart:async';

import 'package:astro_flow/controllers/settings_controller.dart';
import 'package:astro_flow/models/timer_model.dart';
import 'package:astro_flow/screens/about_view.dart';
import 'package:astro_flow/screens/settings_view.dart';
import 'package:astro_flow/services/local_notice_service.dart';
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
              // Info page
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AboutView.routeName);
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ),
              // Settings page
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

  // The intervals and their corresponding break durations.
  final Map<int, Map<String, int?>> _intervals = {
    1: {
      'focus': 25 * 60 * 1000, // Focus for 25 minutes
      'break': 5 * 60 * 1000, // Take a 5 minute break
    },
    2: {
      'focus': 50 * 60 * 1000, // Focus for 50 minutes
      'break': 8 * 60 * 1000, // Take an 8 minute break
    },
    3: {
      'focus': 90 * 60 * 1000, // Focus for 90 minutes
      'break': 10 * 60 * 1000, // Take a 10 minute break
    },
    4: {
      'focus': null, // Anything longer than 90 minutes
      'break': 15 * 60 * 1000, // Take a 15 minute break
    },
  };

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
              // Set work time to 0.
              timerModel.workTime = 0;
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

    // This needs to return milliseconds.
    if (minutes < _intervals[1]!['focus']! ~/ 60000) {
      return _intervals[1]!['break']!;
    } else if (minutes < _intervals[2]!['focus']! ~/ 60000) {
      return _intervals[2]!['break']!;
    } else if (minutes < _intervals[3]!['focus']! ~/ 60000) {
      return _intervals[3]!['break']!;
    } else {
      return _intervals[4]!['break']!;
    }
  }

  // Function to get the next interval.
  int getNextInterval(int milliseconds) {
    // Convert milliseconds to minutes.
    var minutes = milliseconds ~/ 60000;

    // Return the break time for the next interval.
    if (minutes < _intervals[1]!['focus']! ~/ 60000) {
      return 2;
    } else if (minutes < _intervals[2]!['focus']! ~/ 60000) {
      return 3;
    } else if (minutes < _intervals[3]!['focus']! ~/ 60000) {
      return 4;
    } else {
      // Return 4 since there is no interval 5.
      return 4;
    }
  }

  // Get the current interval.
  int getCurrentInterval(int milliseconds) {
    // Convert milliseconds to minutes.
    var minutes = milliseconds ~/ 60000;

    // Return the break time for the next interval.
    if (minutes < _intervals[1]!['focus']! ~/ 60000) {
      return 1;
    } else if (minutes < _intervals[2]!['focus']! ~/ 60000) {
      return 2;
    } else if (minutes < _intervals[3]!['focus']! ~/ 60000) {
      return 3;
    } else {
      return 4;
    }
  }

  // Calculate the percentage of the current interval.
  double calculatePercentageDoneToNextInterval() {
    // The formula is:
    // (time worked - focus time of previous interval) / (focus time of current interval - focus time of previous interval)
    // For example, if the user has worked for 40 minutes, and the focus time of the previous interval is 25 minutes,
    // and the focus time of the current interval is 50 minutes, then the percentage done is:
    // (40 - 25) / (50 - 25) = 15 / 25 = 0.6
    // This means that the user has worked for 60% of the current interval.
    var currentInterval = getCurrentInterval(timerModel.workTime);
    // Current focus time.
    var currentFocusTime = _intervals[currentInterval]!['focus']!;
    // Previous focus time.
    // If the current interval is 1, then the previous focus time is 0.
    var previousFocusTime =
        currentInterval == 1 ? 0 : _intervals[currentInterval - 1]!['focus']!;

    // Calculate the percentage done.
    var percentageDone = (timerModel.workTime - previousFocusTime) /
        (currentFocusTime - previousFocusTime);

    return percentageDone;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: CircularProgressIndicator(
                value: timerModel.onBreak
                    ? timerModel.timeRemaining / timerModel.breakTime
                    : calculatePercentageDoneToNextInterval(),
                strokeWidth: 10,
                backgroundColor: const Color.fromARGB(70, 150, 104, 251),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 245, 41, 214),
                ),
              ),
            ),
            Positioned(
              right: 85,
              top: 62,
              child: Column(
                children: [
                  Text(
                    formatTime(timerModel.onBreak
                        ? timerModel.timeRemaining
                        : timerModel.workTime),
                    style: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Silkscreen',
                    ),
                  ),
                  Text(
                    // If not on break, show the amount of time earned.
                    timerModel.onBreak
                        ? ''
                        : 'Space Out For ${formatTime(timerModel.breakTime)}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          // rounded corners
                          decoration: timerModel.onBreak
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(70, 150, 104, 251),
                                      Color.fromARGB(255, 245, 41, 214),
                                    ],
                                  ),
                                )
                              : BoxDecoration(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    timerModel.onBreak
                                        ? 'Spacing Out'
                                        : _stopwatch.isRunning
                                            ? 'Focusing'
                                            : 'Ready to Focus?',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
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
                                        timerModel.onBreak =
                                            !timerModel.onBreak;
                                        // If the stopwatch is on break, set the break time.
                                        if (timerModel.onBreak) {
                                          var breakTime = calculateBreakTime(
                                              _stopwatch.elapsedMilliseconds);
                                          timerModel.timeRemaining = breakTime;
                                          timerModel.breakTime = breakTime;
                                          timerModel
                                                  .breakFinishedNotificationSent =
                                              false;

                                          // Send a notification when starting a break.
                                          if (timerModel.breakTime > 0) {
                                            // Send a notification.
                                            notificationService
                                                .showNotification(
                                              id: 1,
                                              title: 'Astro Flow',
                                              body:
                                                  'Time to space out for a bit.',
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
                                    icon:
                                        const Icon(Icons.arrow_forward_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // A row of four circles, each representing an interval.
                  // Set the color of the circle from purple to pink, depending on the current interval.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 4; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.all(5),
                          width: 20,
                          height: 20,
                          decoration: timerModel.onBreak
                              ? const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(70, 150, 104, 251),
                                )
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getCurrentInterval(
                                              timerModel.workTime) ==
                                          i
                                      ? const Color.fromARGB(255, 245, 41, 214)
                                      : const Color.fromARGB(70, 150, 104, 251),
                                ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // A circular progress indicator that shows the amount of time left
            // before break increases.
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Description of how long it'll take to get to the next break.
        Text(
          'Focus for at least ${formatTime(_intervals[getCurrentInterval(timerModel.workTime)]!['focus']!)} and you can space out for ${formatTime(_intervals[getNextInterval(timerModel.workTime)]!['break']!)}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
