import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TimerNotifier to manage the session timer
class TimerNotifier extends StateNotifier<Duration> {
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _pausedTime;
  bool isRunning = false;

  TimerNotifier() : super(Duration.zero);

  // Start the timer
  void start() {
    if (!isRunning) {
      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        state = DateTime.now().difference(_startTime!);
      });
      isRunning = true;
    }
  }

  // Stop the timer
  void stop() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
    _startTime = null;
    _pausedTime = null;
    state = Duration.zero;
  }

  // Pause the timer
  void pause() {
    if (isRunning) {
      _pausedTime = DateTime.now();
      _timer?.cancel();
      isRunning = false;
    }
  }

  // Resume the timer from where it was paused
  void resume() {
    if (!isRunning && _pausedTime != null) {
      _startTime = _startTime!.add(DateTime.now().difference(_pausedTime!));
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        state = DateTime.now().difference(_startTime!);
      });
      isRunning = true;
      _pausedTime = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider for the TimerNotifier
final timerProvider = StateNotifierProvider<TimerNotifier, Duration>((ref) {
  return TimerNotifier();
});
