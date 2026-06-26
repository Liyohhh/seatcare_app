import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'main_screen.dart';

class ConnectDeviceScreen extends StatelessWidget {
  const ConnectDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connect Device'),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.bluetooth, size: 80, color: AppColors.accent),
            const SizedBox(height: 20),
            const Text(
              'Connect to your baby seat device',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Later this page will scan and connect to the ESP32 device.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Scan Device'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              ),
              child: const Text('Mock Connect'),
            ),
          ],
        ),
      ),
    );
  }
}