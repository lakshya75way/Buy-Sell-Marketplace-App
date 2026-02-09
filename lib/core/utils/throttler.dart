import 'dart:async';

class Throttler {
  final Duration _duration;
  Timer? _timer;

  Throttler({required Duration duration}) : _duration = duration;

  void run(void Function() action) {
    if (_timer?.isActive ?? false) return;
    _timer = Timer(_duration, () {});
    action();
  }
}
