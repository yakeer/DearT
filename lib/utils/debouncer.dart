import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer(this.duration);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }
}
