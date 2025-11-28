/// Category model representing a transaction category
class Category {
  final int? id;
  final int userId;
  final String name;
  final DateTime createdAt;

  Category({
    this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  /// Converts Category object to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates Category object from Map retrieved from SQLite
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, name, createdAt);
  }
}
