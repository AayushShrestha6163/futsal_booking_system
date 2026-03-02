import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeScreen extends StatefulWidget {
  const GyroscopeScreen({super.key});

  @override
  State<GyroscopeScreen> createState() => _GyroscopeScreenState();
}

class _GyroscopeScreenState extends State<GyroscopeScreen> {
  StreamSubscription<GyroscopeEvent>? _subscription;
  GyroscopeEvent? _event;

  @override
  void initState() {
    super.initState();

    _subscription = gyroscopeEvents.listen((event) {
      setState(() {
        _event = event;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gyroscope Sensor")),
      body: Center(
        child: _event == null
            ? const Text("Move your phone to see rotation data")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("X: ${_event!.x.toStringAsFixed(3)}",
                      style: const TextStyle(fontSize: 20)),
                  Text("Y: ${_event!.y.toStringAsFixed(3)}",
                      style: const TextStyle(fontSize: 20)),
                  Text("Z: ${_event!.z.toStringAsFixed(3)}",
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
      ),
    );
  }
}