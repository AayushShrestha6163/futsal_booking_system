import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeService {
  StreamSubscription<GyroscopeEvent>? _sub;

  void start({
    required void Function(GyroscopeEvent e) onData,
    void Function(Object error)? onError,
  }) {
    _sub = gyroscopeEvents.listen(onData, onError: onError);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}