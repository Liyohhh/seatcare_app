import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SeatCare Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Buckle Status"),
                subtitle: const Text("Secured"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.thermostat),
                title: const Text("Temperature"),
                subtitle: const Text("30°C"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.bluetooth_connected),
                title: const Text("Device Connection"),
                subtitle: const Text("Connected"),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text(
                        "This is a test alert. Later it will trigger from sensors.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Text("Test Alert"),
            ),
          ],
        ),
      ),
    );
  }
}