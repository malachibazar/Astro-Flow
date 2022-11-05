// The model for the Timer widget.
// The model will keep track of which state the timer is in, and the time remaining.
// It also tracks how long the break should be based on the user's settings.

class TimerModel {
  bool onBreak;
  // Break time time is how long the break should be in milliseconds.
  int breakTime;
  // Work time tracks how many milliseconds the user has been working.
  int workTime;
  // Time remaining tracks how many milliseconds the user has left to be on break.
  int timeRemaining;
  // Break finished notification sent
  bool breakFinishedNotificationSent;

  // Constructor
  TimerModel({
    this.onBreak = false,
    this.breakTime = 0,
    this.workTime = 0,
    this.timeRemaining = 0,
    this.breakFinishedNotificationSent = false,
  });
}

class IntervalModel {
  int? focusTime;
  int breakTime;
  bool triggeredNotification;

  IntervalModel({
    this.focusTime = 0,
    this.breakTime = 0,
    this.triggeredNotification = false,
  });
}
