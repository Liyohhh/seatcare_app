import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'core/theme.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connectivity test — writes a value you'll see in the Firebase console.
  await FirebaseDatabase.instance.ref('seatcare/test').set({
    'message': 'Hello from Waby!',
    'time': DateTime.now().toIso8601String(),
  });

  runApp(const WabyApp());
}

class WabyApp extends StatelessWidget {
  const WabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waby',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}