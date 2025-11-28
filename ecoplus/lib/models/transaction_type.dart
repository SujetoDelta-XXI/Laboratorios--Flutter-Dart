/// Enum representing the type of financial transaction
enum TransactionType {
  income,
  expense;

  /// Converts enum to string for database storage
  String toDbString() {
    return name;
  }

  /// Creates TransactionType from database string
  static TransactionType fromDbString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw ArgumentError('Invalid transaction type: $value'),
    );
  }
}
