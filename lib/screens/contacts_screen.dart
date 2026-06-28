import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key, this.showBack = true});

  final bool showBack;
  final ContactService _service = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildMomCard(),
            _buildChildrenSection(context),
            const SizedBox(height: 20),
            _buildFamilyMembersSection(context),
            const SizedBox(height: 20),
            _buildJoinCodeCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                if (showBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                const Text('Family',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Mom profile card ──────────────────────────────────────────────────────

  Widget _buildMomCard() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFD2F7FF),
            border: Border.all(color: const Color(0xFF008FB4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.accent,
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text('Mom',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: Color(0xFF031E2A))),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF008FB4), size: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ── Children section ──────────────────────────────────────────────────────

  Widget _buildChildrenSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Children',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF031E2A))),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6391C9)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Manage',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F61B2))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _childCard(
            name: 'Jason Tan',
            subtitle: '2 year | Battery: 88%',
            subtitleColor: const Color(0xFF031E2A),
            bgColor: const Color(0xFFDEE8F3),
          ),
          const SizedBox(height: 8),
          _childCard(
            name: 'Nur Alysha',
            subtitle: '8 Month | ',
            subtitleExtra: 'Battery: 15%',
            subtitleColor: const Color(0xFF031E2A),
            subtitleExtraColor: const Color(0xFFFF0E0E),
            bgColor: const Color(0xFFFFE5E5),
          ),
        ],
      ),
    );
  }

  Widget _childCard({
    required String name,
    required String subtitle,
    String? subtitleExtra,
    required Color subtitleColor,
    Color? subtitleExtraColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.accent.withAlpha(180),
            child: const Icon(Icons.child_care, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF031E2A))),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Color(0xFF031E2A)),
                    children: [
                      TextSpan(text: subtitle),
                      if (subtitleExtra != null)
                        TextSpan(
                            text: subtitleExtra,
                            style: TextStyle(
                                color: subtitleExtraColor ?? subtitleColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Color(0xFF031E2A), size: 20),
        ],
      ),
    );
  }

  // ── Family Members section ────────────────────────────────────────────────

  Widget _buildFamilyMembersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Family Members',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF031E2A))),
              OutlinedButton(
                onPressed: () => _openAddForm(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6391C9)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('+ Invite',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F61B2))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Contact>>(
            stream: _service.contactsStream().timeout(
              const Duration(seconds: 6),
              onTimeout: (sink) => sink.add([]),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('Could not load contacts.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final contacts = snapshot.data ?? [];
              if (contacts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('No family members yet. Tap + Invite to add.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ),
                );
              }
              return Column(
                children: List.generate(contacts.length, (i) {
                  final c = contacts[i];
                  return Column(
                    children: [
                      _memberRow(context, c, verified: i == 0),
                      if (i < contacts.length - 1)
                        const Divider(
                            color: Colors.black12, height: 1, thickness: 1),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _memberRow(BuildContext context, Contact c, {bool verified = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accent,
            child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF031E2A))),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          size: 14, color: Color(0xFF008FB4)),
                    ],
                  ],
                ),
                Text(c.relation,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0x80031E2A))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert,
                size: 18, color: Color(0xFF031E2A)),
            onPressed: () => _showMemberOptions(context, c),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ── Family Join Code card ─────────────────────────────────────────────────

  Widget _buildJoinCodeCard() {
    const code = 'BT - 8942';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F5FE),
          border: Border.all(
              color: const Color(0xFF1F61B2).withAlpha(80),
              style: BorderStyle.solid,
              width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFBDD6F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFF1F61B2), size: 20),
            ),
            const SizedBox(height: 8),
            const Text('Family Join Code',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF031E2A))),
            const SizedBox(height: 4),
            const Text('Share this code to add new family members',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Color(0x8C031E2A))),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 4,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(code,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D7FB0))),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Clipboard.setData(
                          const ClipboardData(text: code)),
                      child: const Icon(Icons.copy,
                          size: 18, color: Color(0xFF3D7FB0)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showMemberOptions(BuildContext context, Contact c) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accent),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _openEditForm(context, c);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.warning),
              title: const Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, c);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openAddForm(BuildContext context) =>
      _openForm(context);

  void _openEditForm(BuildContext context, Contact c) =>
      _openForm(context, existing: c);

  void _openForm(BuildContext context, {Contact? existing}) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final relCtrl = TextEditingController(text: existing?.relation ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Edit Member' : 'Add Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Name')),
            const SizedBox(height: 12),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(hintText: 'Phone number')),
            const SizedBox(height: 12),
            TextField(
                controller: relCtrl,
                decoration: const InputDecoration(
                    hintText: 'Relation (e.g. Dad, Aunt)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(minimumSize: const Size(88, 44)),
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final phone = phoneCtrl.text.trim();
              final rel = relCtrl.text.trim();
              if (name.isEmpty || phone.isEmpty) return;
              if (isEdit) {
                await _service.updateContact(Contact(
                    id: existing!.id,
                    name: name,
                    phone: phone,
                    relation: rel));
              } else {
                await _service.addContact(
                    name: name, phone: phone, relation: rel);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Contact c) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove member?'),
        content: Text('Remove ${c.name} from your family?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                minimumSize: const Size(88, 44)),
            onPressed: () async {
              await _service.deleteContact(c.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final h = size.height;
    final w = size.width;
    path.lineTo(0, h - 10);
    path.cubicTo(w * 0.12, h - 10, w * 0.20, h - 22, w * 0.32, h - 18);
    path.cubicTo(w * 0.40, h - 14, w * 0.47, h - 8, w * 0.54, h - 10);
    path.cubicTo(w * 0.61, h - 12, w * 0.70, h - 26, w * 0.82, h - 22);
    path.cubicTo(w * 0.90, h - 18, w * 0.96, h - 12, w, h - 12);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
