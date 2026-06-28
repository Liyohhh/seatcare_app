import 'package:flutter/material.dart';
import '../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Local state ───────────────────────────────────────────────────────────
  bool _appAlerts     = true;
  bool _vibration     = true;
  bool _audibleWarn   = false;
  double _distance    = 2;   // meters
  double _alertTimer  = 1;   // minutes

  // ── Design constants ──────────────────────────────────────────────────────
  static const _kGutter        = 20.0;
  static const _kCardRadius    = 12.0;
  static const _kSectionGap    = 24.0;
  static const _kLabelCardGap  =  8.0;
  static const _kRowV          = 14.0;  // vertical padding per row
  static const _kIconSize      = 36.0;
  // Light-blue chip tint derived from theme
  static const _kIconBg = Color(0xFFD4EEF8);

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: _kSectionGap),
            _buildProfileCard(),
            const SizedBox(height: _kSectionGap),

            // ── Notifications ────────────────────────────────────────────
            _sectionLabel('Notifications'),
            const SizedBox(height: _kLabelCardGap),
            _card([
              _toggleRow(Icons.notifications_outlined, 'App Alerts',       _appAlerts,   (v) => setState(() => _appAlerts   = v)),
              _divider(),
              _toggleRow(Icons.vibration,              'Vibration',         _vibration,   (v) => setState(() => _vibration   = v)),
              _divider(),
              _toggleRow(Icons.volume_up_outlined,     'Audible Warning',   _audibleWarn, (v) => setState(() => _audibleWarn = v)),
            ]),
            const SizedBox(height: _kSectionGap),

            // ── Distance Setting ─────────────────────────────────────────
            _sectionLabel('Distance Setting'),
            const SizedBox(height: _kLabelCardGap),
            _card([
              _sliderRow(
                icon: Icons.social_distance_outlined,
                label: 'Far Distance Alert',
                value: _distance,
                min: 1, max: 5, divisions: 4,
                badgeText: '${_distance.round()} m',
                onChanged: (v) => setState(() => _distance = v),
              ),
              _divider(),
              _sliderRow(
                icon: Icons.timer_outlined,
                label: 'Auto-alert timer',
                value: _alertTimer,
                min: 1, max: 5, divisions: 4,
                badgeText: '${_alertTimer.round()} min',
                onChanged: (v) => setState(() => _alertTimer = v),
              ),
            ]),
            const SizedBox(height: _kSectionGap),

            // ── Connectivity & Access ─────────────────────────────────────
            _sectionLabel('Connectivity & Access'),
            const SizedBox(height: _kLabelCardGap),
            _card([
              _navRow(Icons.bluetooth,       'Bluetooth Devices',  subtitle: 'Not connected'),
              _divider(),
              _navRow(Icons.people_outlined, 'Family Management',  subtitle: '3 members'),
            ]),
            const SizedBox(height: _kSectionGap),

            // ── Support & Safety ──────────────────────────────────────────
            _sectionLabel('Support & Safety'),
            const SizedBox(height: _kLabelCardGap),
            _card([
              _navRow(Icons.shield_outlined, 'Privacy & Data'),
              _divider(),
              _navRow(Icons.help_outline,    'Help & Support'),
            ]),
            const SizedBox(height: 32),

            // ── Sign Out ──────────────────────────────────────────────────
            _buildSignOut(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ── Header (wave — identical to Home & Family) ────────────────────────────

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: kHeaderGradient),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(_kGutter, 18, _kGutter, 0),
            child: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Profile card ──────────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kGutter),
      child: _cardContainer(
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _kIconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.accent, size: 26),
            ),
            const SizedBox(width: 14),
            // Name & label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Mom',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  SizedBox(height: 2),
                  Text('Account owner',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kGutter),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────

  Widget _card(List<Widget> rows) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kGutter),
      child: _cardContainer(child: Column(children: rows)),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kCardRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() => const Divider(
        height: 1,
        thickness: 0.5,
        indent: _kGutter + _kIconSize + 14,
        endIndent: 0,
        color: Color(0xFFE5EAF0),
      );

  // ── Toggle row ────────────────────────────────────────────────────────────

  Widget _toggleRow(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _kGutter, vertical: _kRowV),
      child: Row(
        children: [
          _iconBubble(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.dot,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD1D5DB),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  // ── Slider row ────────────────────────────────────────────────────────────

  Widget _sliderRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String badgeText,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_kGutter, _kRowV, _kGutter, 8),
      child: Column(
        children: [
          // ── Top row: icon + label + value badge ──
          Row(
            children: [
              _iconBubble(icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // ── Slider ──
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              activeTrackColor: AppColors.dot,
              inactiveTrackColor: const Color(0xFFD1D5DB),
              thumbColor: AppColors.accent,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 14),
              overlayColor: AppColors.accent.withAlpha(30),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          // ── Range labels ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.round()}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text('${max.round()}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Nav row ───────────────────────────────────────────────────────────────

  Widget _navRow(IconData icon, String label, {String? subtitle}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(_kCardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: _kGutter, vertical: _kRowV),
        child: Row(
          children: [
            _iconBubble(icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Icon bubble ───────────────────────────────────────────────────────────

  Widget _iconBubble(IconData icon) {
    return Container(
      width: _kIconSize,
      height: _kIconSize,
      decoration: const BoxDecoration(
        color: _kIconBg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.accent, size: 20),
    );
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  Widget _buildSignOut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kGutter),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_kCardRadius)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20, color: Colors.white),
              SizedBox(width: 10),
              Text('Sign Out',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Wave clipper (identical to Home & Family) ─────────────────────────────

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final h = size.height;
    final w = size.width;
    final path = Path()
      ..lineTo(0, h - 10)
      ..cubicTo(w * 0.12, h - 10, w * 0.20, h - 22, w * 0.32, h - 18)
      ..cubicTo(w * 0.40, h - 14, w * 0.47, h - 8,  w * 0.54, h - 10)
      ..cubicTo(w * 0.61, h - 12, w * 0.70, h - 26, w * 0.82, h - 22)
      ..cubicTo(w * 0.90, h - 18, w * 0.96, h - 12, w,        h - 12)
      ..lineTo(w, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
