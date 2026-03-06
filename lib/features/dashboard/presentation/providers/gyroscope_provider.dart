import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futal_booking_system/core/services/sensors/gyroscope_service.dart';
import 'package:sensors_plus/sensors_plus.dart';


class GyroscopeData {
  final double x;
  final double y;
  final double z;

  const GyroscopeData({
    required this.x,
    required this.y,
    required this.z,
  });

  const GyroscopeData.initial()
      : x = 0,
        y = 0,
        z = 0;
}

class GyroscopeNotifier extends StateNotifier<GyroscopeData> {
  final GyroscopeService _service;

  GyroscopeNotifier(this._service) : super(const GyroscopeData.initial()) {
    _start();
  }

  void _start() {
    _service.start(
      onData: (GyroscopeEvent e) {
        state = GyroscopeData(
          x: e.x,
          y: e.y,
          z: e.z,
        );
      },
    );
  }

  Future<void> stop() async {
    await _service.stop();
  }

  @override
  void dispose() {
    _service.stop();
    super.dispose();
  }
}

final gyroscopeServiceProvider = Provider<GyroscopeService>((ref) {
  return GyroscopeService();
});

final gyroscopeProvider =
    StateNotifierProvider<GyroscopeNotifier, GyroscopeData>((ref) {
  final service = ref.watch(gyroscopeServiceProvider);
  return GyroscopeNotifier(service);
});