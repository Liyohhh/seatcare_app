import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import 'main_screen.dart';

class ConnectDeviceScreen extends StatefulWidget {
  const ConnectDeviceScreen({super.key});

  @override
  State<ConnectDeviceScreen> createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  static const _channel = MethodChannel('waby/bluetooth');

  bool _scanning = false;
  String? _connectedDevice;
  String? _errorMsg;

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _errorMsg = null;
      _connectedDevice = null;
    });

    try {
      // Calls MainActivity → CompanionDeviceManager → native Android picker
      final deviceName =
          await _channel.invokeMethod<String>('showDevicePicker');

      if (!mounted) return;
      setState(() {
        _scanning = false;
        _connectedDevice = deviceName;
      });

      // Small delay so the user sees the "Connected" state before navigating
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _connectedDevice = null;
        if (e.code != 'CANCELLED') {
          _errorMsg = e.message ?? 'Something went wrong. Please try again.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connect Device'),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon / status indicator ──────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _scanning
                  ? _pulsingIcon()
                  : _connectedDevice != null
                      ? const Icon(Icons.check_circle,
                          size: 90, color: Color(0xFF56B337), key: ValueKey('ok'))
                      : const Icon(Icons.bluetooth,
                          size: 90, color: AppColors.accent, key: ValueKey('bt')),
            ),
            const SizedBox(height: 24),

            // ── Title ────────────────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _connectedDevice != null
                    ? 'Connected!'
                    : _scanning
                        ? 'Looking for devices…'
                        : 'Connect to Waby Seat',
                key: ValueKey(_scanning.toString() + (_connectedDevice ?? '')),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // ── Subtitle ─────────────────────────────────────────────────────
            Text(
              _connectedDevice != null
                  ? 'Paired with $_connectedDevice'
                  : _scanning
                      ? 'The Android device picker will appear.\nChoose your ESP32 seat device.'
                      : 'Make sure your seat device is powered\non and within range.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            // ── Error message ────────────────────────────────────────────────
            if (_errorMsg != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMsg!,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.warning)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 36),

            // ── Scan button ──────────────────────────────────────────────────
            if (!_scanning && _connectedDevice == null)
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _startScan,
                    icon: const Icon(Icons.bluetooth_searching),
                    label: const Text('Scan Device'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: const Text('Mock Connect'),
                  ),
                ],
              ),

            // ── Scanning spinner ─────────────────────────────────────────────
            if (_scanning)
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: AppColors.accent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pulsingIcon() {
    return TweenAnimationBuilder<double>(
      key: const ValueKey('pulse'),
      tween: Tween(begin: 0.9, end: 1.1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: const Icon(Icons.bluetooth_searching,
          size: 90, color: AppColors.accent),
    );
  }
}
