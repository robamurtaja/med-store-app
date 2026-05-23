import 'dart:async';
import 'package:hooks_riverpod/legacy.dart';

class TimerState {
  final int remainingTime;
  final bool isTimerRunning;

  TimerState({required this.remainingTime, required this.isTimerRunning});
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier()
    : super(
        TimerState(
          remainingTime: 60,
          isTimerRunning: false,
        ), // ⬅️ 1 minute = 60 seconds
      );

  Timer? _timer;

  void startTimer() {
    if (state.isTimerRunning) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = TimerState(
          remainingTime: state.remainingTime - 1,
          isTimerRunning: true,
        );
      } else {
        _timer?.cancel();
        state = TimerState(remainingTime: 0, isTimerRunning: false);
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    state = TimerState(
      remainingTime: 60, // ⬅️ Also change here
      isTimerRunning: false,
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider =
    StateNotifierProvider.autoDispose<TimerNotifier, TimerState>((ref) {
      return TimerNotifier();
    });
