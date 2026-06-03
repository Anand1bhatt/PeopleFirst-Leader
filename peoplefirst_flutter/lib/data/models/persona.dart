enum PersonaType { leader, employee }

class Persona {
  final PersonaType type;
  final String name;
  final String role;
  final String department;
  final String initials;
  final String orgSize;

  const Persona({
    required this.type,
    required this.name,
    required this.role,
    required this.department,
    required this.initials,
    required this.orgSize,
  });

  Persona copyWith({
    PersonaType? type,
    String? name,
    String? role,
    String? department,
    String? initials,
    String? orgSize,
  }) {
    return Persona(
      type: type ?? this.type,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      initials: initials ?? this.initials,
      orgSize: orgSize ?? this.orgSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Persona &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name &&
          role == other.role;

  @override
  int get hashCode => type.hashCode ^ name.hashCode ^ role.hashCode;

  static const Persona leader = Persona(
    type: PersonaType.leader,
    name: 'Vikram',
    role: 'VP, Product & Engineering',
    department: 'Product & Engineering',
    initials: 'VS',
    orgSize: '250',
  );

  static const Persona employee = Persona(
    type: PersonaType.employee,
    name: 'Priya',
    role: 'Senior Product Designer',
    department: 'Design',
    initials: 'PN',
    orgSize: '1',
  );
}
