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
            const SizedBox(height: 20),
            _sounds(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  _ChildCard(
                    name: 'Jason Tan',
                    info: 'DOB: 15 Jan 2026    Weight: 8.5kg',
                    safe: true,
                    buckled: true,
                    near: true,
                    battery: 88,
                  ),
                  SizedBox(height: 14),
                  _ChildCard(
                    name: 'Nur Alysha',
                    info: 'DOB: 15 Jan 2026    Weight: 8.5kg',
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
    return Stack(
      children: [
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: kHeaderGradient),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.person, color: AppColors.accent, size: 28),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi, Mom!',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15)),
                          Text('Welcome back!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Icon(Icons.home_filled, color: Colors.white, size: 30),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.thermostat,
                                  color: Colors.white, size: 40),
                              SizedBox(width: 4),
                              Text('23°C',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text("Mom's car",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: const LinearProgressIndicator(
                              value: 0.35,
                              minHeight: 6,
                              backgroundColor: Colors.white30,
                              color: Colors.white,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('20°C',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                Text('32°C',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/car_pic_on_top.png',
                      width: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) =>
                          const SizedBox(width: 150, height: 70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sounds() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favourite Sounds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              _soundChip(Icons.play_arrow, 'Rainyday'),
              const SizedBox(width: 10),
              _soundChip(Icons.play_arrow, 'Dreamy'),
              const SizedBox(width: 10),
              _soundChip(Icons.add, 'Add'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _soundChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
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
                            fontSize: 12, color: AppColors.textSecondary)),
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

/// Curved wave shape for the header bottom edge.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(
        size.width * 0.78, size.height - 64, size.width, size.height - 24);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}