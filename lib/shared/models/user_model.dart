class User {
  final String id;
  final String name;
  final String contact;

  const User({
    required this.id,
    required this.name,
    required this.contact,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'contact': contact,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as String,
        name: map['name'] as String,
        contact: map['contact'] as String,
      );

  User copyWith({
    String? id,
    String? name,
    String? contact,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        contact: contact ?? this.contact,
      );
}
