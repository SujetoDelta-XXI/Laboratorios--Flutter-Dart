import 'package:flutter_test/flutter_test.dart';
import 'package:ecoplus/models/user.dart';
import 'package:ecoplus/models/transaction.dart';
import 'package:ecoplus/models/transaction_type.dart';
import 'package:ecoplus/models/category.dart';

void main() {
  group('User Model Serialization', () {
    test('toMap converts User to Map correctly', () {
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final user = User(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        createdAt: createdAt,
      );

      final map = user.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@example.com');
      expect(map['password'], 'password123');
      expect(map['created_at'], createdAt.toIso8601String());
    });

    test('toMap handles null id correctly', () {
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final user = User(
        name: 'Jane Doe',
        email: 'jane@example.com',
        password: 'password456',
        createdAt: createdAt,
      );

      final map = user.toMap();

      expect(map['id'], isNull);
      expect(map['name'], 'Jane Doe');
      expect(map['email'], 'jane@example.com');
    });

    test('fromMap creates User from Map correctly', () {
      final createdAtString = DateTime(2024, 1, 15, 10, 30).toIso8601String();
      final map = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'password123',
        'created_at': createdAtString,
      };

      final user = User.fromMap(map);

      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.password, 'password123');
      expect(user.createdAt, DateTime.parse(createdAtString));
    });

    test('fromMap handles null id correctly', () {
      final createdAtString = DateTime(2024, 1, 15, 10, 30).toIso8601String();
      final map = {
        'id': null,
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'password': 'password456',
        'created_at': createdAtString,
      };

      final user = User.fromMap(map);

      expect(user.id, isNull);
      expect(user.name, 'Jane Doe');
      expect(user.email, 'jane@example.com');
    });

    test('toMap and fromMap round trip preserves data', () {
      final original = User(
        id: 42,
        name: 'Test User',
        email: 'test@example.com',
        password: 'securepass',
        createdAt: DateTime(2024, 3, 20, 14, 45),
      );

      final map = original.toMap();
      final restored = User.fromMap(map);

      expect(restored, equals(original));
    });

    test('toMap and fromMap round trip with null id preserves data', () {
      final original = User(
        name: 'New User',
        email: 'new@example.com',
        password: 'newpass',
        createdAt: DateTime(2024, 3, 20, 14, 45),
      );

      final map = original.toMap();
      final restored = User.fromMap(map);

      expect(restored, equals(original));
    });
  });

  group('Transaction Model Serialization', () {
    test('toMap converts Transaction to Map correctly for income', () {
      final date = DateTime(2024, 1, 15);
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final transaction = Transaction(
        id: 1,
        userId: 10,
        type: TransactionType.income,
        amount: 1500.50,
        description: 'Salary payment',
        categoryId: 5,
        date: date,
        createdAt: createdAt,
      );

      final map = transaction.toMap();

      expect(map['id'], 1);
      expect(map['user_id'], 10);
      expect(map['type'], 'income');
      expect(map['amount'], 1500.50);
      expect(map['description'], 'Salary payment');
      expect(map['category_id'], 5);
      expect(map['date'], date.toIso8601String());
      expect(map['created_at'], createdAt.toIso8601String());
    });

    test('toMap converts Transaction to Map correctly for expense', () {
      final date = DateTime(2024, 1, 16);
      final createdAt = DateTime(2024, 1, 16, 11, 0);
      final transaction = Transaction(
        id: 2,
        userId: 10,
        type: TransactionType.expense,
        amount: 75.25,
        description: 'Grocery shopping',
        categoryId: 3,
        date: date,
        createdAt: createdAt,
      );

      final map = transaction.toMap();

      expect(map['type'], 'expense');
      expect(map['amount'], 75.25);
      expect(map['description'], 'Grocery shopping');
    });

    test('toMap handles null id correctly', () {
      final transaction = Transaction(
        userId: 10,
        type: TransactionType.income,
        amount: 100.0,
        description: 'Bonus',
        categoryId: 5,
        date: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = transaction.toMap();

      expect(map['id'], isNull);
      expect(map['user_id'], 10);
    });

    test('fromMap creates Transaction from Map correctly for income', () {
      final dateString = DateTime(2024, 1, 15).toIso8601String();
      final createdAtString = DateTime(2024, 1, 15, 10, 30).toIso8601String();
      final map = {
        'id': 1,
        'user_id': 10,
        'type': 'income',
        'amount': 1500.50,
        'description': 'Salary payment',
        'category_id': 5,
        'date': dateString,
        'created_at': createdAtString,
      };

      final transaction = Transaction.fromMap(map);

      expect(transaction.id, 1);
      expect(transaction.userId, 10);
      expect(transaction.type, TransactionType.income);
      expect(transaction.amount, 1500.50);
      expect(transaction.description, 'Salary payment');
      expect(transaction.categoryId, 5);
      expect(transaction.date, DateTime.parse(dateString));
      expect(transaction.createdAt, DateTime.parse(createdAtString));
    });

    test('fromMap creates Transaction from Map correctly for expense', () {
      final dateString = DateTime(2024, 1, 16).toIso8601String();
      final createdAtString = DateTime(2024, 1, 16, 11, 0).toIso8601String();
      final map = {
        'id': 2,
        'user_id': 10,
        'type': 'expense',
        'amount': 75.25,
        'description': 'Grocery shopping',
        'category_id': 3,
        'date': dateString,
        'created_at': createdAtString,
      };

      final transaction = Transaction.fromMap(map);

      expect(transaction.type, TransactionType.expense);
      expect(transaction.amount, 75.25);
      expect(transaction.description, 'Grocery shopping');
    });

    test('fromMap handles null id correctly', () {
      final map = {
        'id': null,
        'user_id': 10,
        'type': 'income',
        'amount': 100.0,
        'description': 'Bonus',
        'category_id': 5,
        'date': DateTime(2024, 1, 15).toIso8601String(),
        'created_at': DateTime(2024, 1, 15, 10, 30).toIso8601String(),
      };

      final transaction = Transaction.fromMap(map);

      expect(transaction.id, isNull);
      expect(transaction.userId, 10);
    });

    test('toMap and fromMap round trip preserves data for income', () {
      final original = Transaction(
        id: 42,
        userId: 10,
        type: TransactionType.income,
        amount: 2500.75,
        description: 'Freelance work',
        categoryId: 8,
        date: DateTime(2024, 3, 20),
        createdAt: DateTime(2024, 3, 20, 14, 45),
      );

      final map = original.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored, equals(original));
    });

    test('toMap and fromMap round trip preserves data for expense', () {
      final original = Transaction(
        id: 43,
        userId: 10,
        type: TransactionType.expense,
        amount: 150.00,
        description: 'Utilities bill',
        categoryId: 2,
        date: DateTime(2024, 3, 21),
        createdAt: DateTime(2024, 3, 21, 9, 15),
      );

      final map = original.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored, equals(original));
    });

    test('toMap and fromMap round trip with null id preserves data', () {
      final original = Transaction(
        userId: 10,
        type: TransactionType.income,
        amount: 500.0,
        description: 'Gift',
        categoryId: 7,
        date: DateTime(2024, 3, 22),
        createdAt: DateTime(2024, 3, 22, 16, 0),
      );

      final map = original.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored, equals(original));
    });
  });

  group('Category Model Serialization', () {
    test('toMap converts Category to Map correctly', () {
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final category = Category(
        id: 1,
        userId: 10,
        name: 'Food',
        createdAt: createdAt,
      );

      final map = category.toMap();

      expect(map['id'], 1);
      expect(map['user_id'], 10);
      expect(map['name'], 'Food');
      expect(map['created_at'], createdAt.toIso8601String());
    });

    test('toMap handles null id correctly', () {
      final createdAt = DateTime(2024, 1, 15, 10, 30);
      final category = Category(
        userId: 10,
        name: 'Transport',
        createdAt: createdAt,
      );

      final map = category.toMap();

      expect(map['id'], isNull);
      expect(map['user_id'], 10);
      expect(map['name'], 'Transport');
    });

    test('fromMap creates Category from Map correctly', () {
      final createdAtString = DateTime(2024, 1, 15, 10, 30).toIso8601String();
      final map = {
        'id': 1,
        'user_id': 10,
        'name': 'Food',
        'created_at': createdAtString,
      };

      final category = Category.fromMap(map);

      expect(category.id, 1);
      expect(category.userId, 10);
      expect(category.name, 'Food');
      expect(category.createdAt, DateTime.parse(createdAtString));
    });

    test('fromMap handles null id correctly', () {
      final createdAtString = DateTime(2024, 1, 15, 10, 30).toIso8601String();
      final map = {
        'id': null,
        'user_id': 10,
        'name': 'Transport',
        'created_at': createdAtString,
      };

      final category = Category.fromMap(map);

      expect(category.id, isNull);
      expect(category.userId, 10);
      expect(category.name, 'Transport');
    });

    test('toMap and fromMap round trip preserves data', () {
      final original = Category(
        id: 42,
        userId: 10,
        name: 'Entertainment',
        createdAt: DateTime(2024, 3, 20, 14, 45),
      );

      final map = original.toMap();
      final restored = Category.fromMap(map);

      expect(restored, equals(original));
    });

    test('toMap and fromMap round trip with null id preserves data', () {
      final original = Category(
        userId: 10,
        name: 'Healthcare',
        createdAt: DateTime(2024, 3, 20, 14, 45),
      );

      final map = original.toMap();
      final restored = Category.fromMap(map);

      expect(restored, equals(original));
    });
  });

  group('Edge Cases', () {
    test('User with empty string fields serializes correctly', () {
      final user = User(
        id: 1,
        name: '',
        email: '',
        password: '',
        createdAt: DateTime(2024, 1, 15),
      );

      final map = user.toMap();
      final restored = User.fromMap(map);

      expect(restored.name, '');
      expect(restored.email, '');
      expect(restored.password, '');
    });

    test('Transaction with zero amount serializes correctly', () {
      final transaction = Transaction(
        id: 1,
        userId: 10,
        type: TransactionType.income,
        amount: 0.0,
        description: 'Zero amount',
        categoryId: 5,
        date: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = transaction.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored.amount, 0.0);
    });

    test('Transaction with empty description serializes correctly', () {
      final transaction = Transaction(
        id: 1,
        userId: 10,
        type: TransactionType.expense,
        amount: 50.0,
        description: '',
        categoryId: 5,
        date: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = transaction.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored.description, '');
    });

    test('Category with empty name serializes correctly', () {
      final category = Category(
        id: 1,
        userId: 10,
        name: '',
        createdAt: DateTime(2024, 1, 15),
      );

      final map = category.toMap();
      final restored = Category.fromMap(map);

      expect(restored.name, '');
    });

    test('Transaction with very large amount serializes correctly', () {
      final transaction = Transaction(
        id: 1,
        userId: 10,
        type: TransactionType.income,
        amount: 999999999.99,
        description: 'Large amount',
        categoryId: 5,
        date: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = transaction.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored.amount, 999999999.99);
    });

    test('Transaction with fractional cents serializes correctly', () {
      final transaction = Transaction(
        id: 1,
        userId: 10,
        type: TransactionType.expense,
        amount: 10.999,
        description: 'Fractional amount',
        categoryId: 5,
        date: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = transaction.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored.amount, 10.999);
    });
  });
}
