import 'dart:async';

class DebounceHelper {
  Timer? _timer;

  void debounce(void Function() action,
      {Duration duration = const Duration(milliseconds: 500)}) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(duration, action);
  }
}
