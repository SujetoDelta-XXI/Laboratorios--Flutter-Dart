import 'transaction_type.dart';

/// Transaction model representing a financial transaction (income or expense)
class Transaction {
  final int? id;
  final int userId;
  final TransactionType type;
  final double amount;
  final String description;
  final int categoryId;
  final DateTime date;
  final DateTime createdAt;

  Transaction({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.date,
    required this.createdAt,
  });

  /// Converts Transaction object to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toDbString(),
      'amount': amount,
      'description': description,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates Transaction object from Map retrieved from SQLite
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      type: TransactionType.fromDbString(map['type'] as String),
      amount: map['amount'] as double,
      description: map['description'] as String,
      categoryId: map['category_id'] as int,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.amount == amount &&
        other.description == description &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      type,
      amount,
      description,
      categoryId,
      date,
      createdAt,
    );
  }
}
