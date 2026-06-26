class Contact {
  final String id;
  final String name;
  final String phone;
  final String relation;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory Contact.fromMap(String id, Map<dynamic, dynamic> map) => Contact(
        id: id,
        name: (map['name'] ?? '') as String,
        phone: (map['phone'] ?? '') as String,
        relation: (map['relation'] ?? '') as String,
      );
}