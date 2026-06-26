import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key, this.showBack = true});

  /// Show a back button (true when pushed as its own page; false inside a tab).
  final bool showBack;
  final ContactService _service = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(showBack ? 12 : 24, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: kHeaderGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                if (showBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                const Text(
                  'Emergency Contacts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Contact>>(
              stream: _service.contactsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final contacts = snapshot.data ?? [];
                if (contacts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No contacts yet.\nTap + to add your first next-of-kin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _contactCard(context, contacts[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.navy,
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _contactCard(BuildContext context, Contact c) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.safeCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title:
            Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${c.relation} • ${c.phone}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.accent),
              onPressed: () => _openForm(context, existing: c),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.warning),
              onPressed: () => _confirmDelete(context, c),
            ),
          ],
        ),
      ),
    );
  }

  void _openForm(BuildContext context, {Contact? existing}) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final relCtrl = TextEditingController(text: existing?.relation ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Edit Contact' : 'Add Contact'),
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
                decoration: const InputDecoration(hintText: 'Phone number')),
            const SizedBox(height: 12),
            TextField(
                controller: relCtrl,
                decoration:
                    const InputDecoration(hintText: 'Relation (e.g. Father)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(88, 44)),
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final phone = phoneCtrl.text.trim();
              final rel = relCtrl.text.trim();
              if (name.isEmpty || phone.isEmpty) return;
              if (isEdit) {
                await _service.updateContact(Contact(
                    id: existing!.id, name: name, phone: phone, relation: rel));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete contact?'),
        content: Text('Remove ${c.name} from your contacts?'),
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