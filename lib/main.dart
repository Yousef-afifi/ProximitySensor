import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart' as foundation;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proximity Sensor Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProximityPage(),
    );
  }
}

class ProximityPage extends StatefulWidget {
  const ProximityPage({super.key});

  @override
  State<ProximityPage> createState() => _ProximityPageState();
}

class _ProximityPageState extends State<ProximityPage> {
  bool _isNear = false;
  late StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    _listenToSensor();
  }

  void _listenToSensor() {

    _subscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isNear ? Colors.red : Colors.green,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isNear ? Icons.warning_rounded : Icons.check_circle_outline,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              _isNear ? 'OBJECT DETECTED' : 'NO OBJECT NEARBY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isNear ? Colors.red.shade700 : Colors.green.shade700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _isNear 
                  ? 'The object is currently less than 20cm away from the screen.' 
                  : 'The area in front of the screen is clear.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            if (foundation.kDebugMode) ...[
               const SizedBox(height: 40),
               const Text(
                 'Note: Proximity sensors on most phones are binary (Near/Far) and may not provide exact distance in cm.',
                 textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
               ),
            ]
          ],
        ),
      ),
    );
  }
}
