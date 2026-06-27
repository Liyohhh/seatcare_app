import 'dart:math' show pi;
import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Waby home dashboard. Uses static/mock values for now — temperature and the
/// children will be wired to live Firebase data (seatcare/live) in the next step.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 8),
            _sounds(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  _ChildCard(
                    name: 'Jason Tan',
                    info: 'DOB: 15 Jan 2026\nWeight: 8.5kg | Height: 73cm',
                    safe: true,
                    buckled: true,
                    near: true,
                    battery: 88,
                  ),
                  SizedBox(height: 14),
                  _ChildCard(
                    name: 'Nur Alysha',
                    info: 'DOB: 15 Jan 2026\nWeight: 8.5kg | Height: 73cm',
                    safe: false,
                    buckled: false,
                    near: false,
                    battery: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add Device'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    // Outer Stack: bg → wave → car (on top of wave) → text
    return Stack(
      children: [
        // ── 1. Light blue background ────────────────────────────────────────
        Positioned.fill(child: Container(color: const Color(0xFFE5FCFF).withAlpha(180))),

        // ── 2. Wave gradient (behind the car) ───────────────────────────────
              ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(gradient: kHeaderGradient),
                ),
              ),

        // ── 3. Car image — ON TOP of wave, beside temperature content ────────
        //    left+right pins the car to the right half; Center handles
        //    horizontal centering regardless of image aspect ratio.
        Positioned(
          left: 210,
          right: -15,
          top: 95,
          bottom: 0,
          child: Center(
              child: RotatedBox(
              quarterTurns: 1, // +90° → front of car faces up
              child: Image.asset(
                'assets/images/car_pic_on_top.png',
                height: 85, // controls visual width after rotation
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const SizedBox(),
              ),
            ),
          ),
        ),

        // ── 4. Profile row (always on top) ──────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.accent, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, Mom!',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text('Welcome back!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Icon(Icons.home_filled, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),

        // ── 5. Temperature section (below the wave, left side only) ─────────
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Left half only — the car occupies the right portion
                final leftWidth = constraints.maxWidth * 0.55;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.thermostat, color: Color(0xFF0063BA), size: 64),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('23°C',
                                style: TextStyle(
                                    color: Color(0xFF0063BA),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800)),
                            Text("Mom's car",
                                style: TextStyle(color: Color(0xFF031E2A), fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: leftWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: 0.35,
                          minHeight: 6,
                          backgroundColor: Colors.black12,
                          color: Color(0xFF088BEA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: leftWidth,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('20°C',
                              style: TextStyle(
                                  color: Color(0xFF031E2A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                          Text('32°C',
                              style: TextStyle(
                                  color: Color(0xFF031E2A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _sounds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Favourite Sounds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _soundChip(Icons.play_arrow, 'Rainyday'),
              const SizedBox(width: 10),
              _soundChip(Icons.play_arrow, 'Dreamy'),
              const SizedBox(width: 10),
              _soundChip(Icons.play_arrow, 'Ocean'),
              const SizedBox(width: 10),
              _soundChip(Icons.play_arrow, 'Lullaby'),
              const SizedBox(width: 10),
              _soundChip(Icons.add, 'Add sound'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _soundChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF018FB4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

/// A single child's status card (tinted blue when safe, pink when warning).
class _ChildCard extends StatelessWidget {
  final String name;
  final String info;
  final bool safe;
  final bool buckled;
  final bool near;
  final int battery;

  const _ChildCard({
    required this.name,
    required this.info,
    required this.safe,
    required this.buckled,
    required this.near,
    required this.battery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: safe ? AppColors.safeCard : AppColors.warningCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.accent,
                child: Text(name.isNotEmpty ? name[0] : '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(info,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textSecondary, height: 1.5)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: safe ? AppColors.safe : AppColors.warning,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(safe ? 'SAFE' : 'WARNING',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill(buckled ? Icons.link : Icons.link_off,
                  buckled ? 'Latched' : 'Unlatched'),
              const SizedBox(width: 8),
              _pill(Icons.location_on, near ? 'Near' : 'Far'),
              const SizedBox(width: 8),
              _pill(Icons.battery_full, '$battery%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: safe ? AppColors.accent : AppColors.warning,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two-loop wave: small crest on the left, bigger crest on the right.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final h = size.height;
    final w = size.width;

    path.lineTo(0, h - 10);

    // ── Left crest — flat, subtle bump ────────────────────────────────────
    path.cubicTo(
      w * 0.12, h - 10,
      w * 0.20, h - 22,
      w * 0.32, h - 18,
    );
    // Trough
    path.cubicTo(
      w * 0.40, h - 14,
      w * 0.47, h - 8,
      w * 0.54, h - 10,
    );

    // ── Right crest — gentle, flattened bump ──────────────────────────────
    path.cubicTo(
      w * 0.61, h - 12,
      w * 0.70, h - 26,
      w * 0.82, h - 22,
    );
    // Settle to right edge
    path.cubicTo(
      w * 0.90, h - 18,
      w * 0.96, h - 12,
      w, h - 12,
    );

    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}