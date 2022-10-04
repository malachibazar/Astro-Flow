import 'dart:async';

import 'package:astro_flow/src/settings/settings_controller.dart';
import 'package:astro_flow/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

int calculateBreakTime(int milliseconds) {
  // Convert milliseconds to minutes.
  var minutes = milliseconds ~/ 60000;
  // If the minutes are less than 5, return 2 minutes.
  // If the minutes are 5-25, return 5 minutes.
  // If the minutes are 25-50, return 10 minutes.
  // Otherwise, return 15 minutes.
  // This needs to return milliseconds.
  if (minutes < 1) {
    return 0;
  } else if (minutes < 5) {
    return 2 * 60000;
  } else if (minutes < 25) {
    return 5 * 60000;
  } else if (minutes < 50) {
    return 10 * 60000;
  } else {
    return 15 * 60000;
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

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
            children: const [
              StopwatchControl(),
            ],
          ),
        ],
      ),
    );
  }
}

// the timer view
class StopwatchControl extends StatefulWidget {
  const StopwatchControl({super.key});

  @override
  State<StopwatchControl> createState() => _StopwatchControlState();
}

class _StopwatchControlState extends State<StopwatchControl> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  // Tracks if on break or on work
  bool _onBreak = false;
  // Tracks the number of milliseconds needed for the break
  int _breakTime = 0;
  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        // If the stopwatch is on break, decrease the break time by 30ms.
        // Also, the break time should never be less than 0.
        if (_onBreak) {
          _breakTime = (_breakTime - 30).clamp(0, _breakTime);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _onBreak ? 'Spacing Out' : 'Working',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 5),
        Text(
          formatTime(_onBreak ? _breakTime : _stopwatch.elapsedMilliseconds),
          style: const TextStyle(fontSize: 48.0),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 100,
          child: Container(
            // rounded corners
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey,
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
                  onPressed: () {
                    setState(() {
                      _onBreak = !_onBreak;
                      // If the stopwatch is on break, set the break time.
                      if (_onBreak) {
                        _breakTime =
                            calculateBreakTime(_stopwatch.elapsedMilliseconds);
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
      ],
    );
  }
}
