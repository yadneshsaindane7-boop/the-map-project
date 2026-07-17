class EventType {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const EventType({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory EventType.fromMap(Map<String, dynamic> map) {
    return EventType(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  EventType copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return EventType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'EventType(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventType &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      createdAt,
    );
  }
}