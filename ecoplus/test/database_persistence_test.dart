import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:math';

import 'package:ecoplus/database/database_helper.dart';
import 'package:ecoplus/models/user.dart';
import 'package:ecoplus/models/category.dart';
import 'package:ecoplus/models/transaction.dart' as app_models;
import 'package:ecoplus/models/transaction_type.dart';

void main() {
  // Initialize FFI for testing
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Database Persistence Property Tests', () {
    late String testDbPath;
    final random = Random();

    setUp(() async {
      // Create a unique test database path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      testDbPath = join(Directory.systemTemp.path, 'test_finance_$timestamp.db');
    });

    tearDown(() async {
      // Clean up test database
      try {
        await DatabaseHelper.instance.close();
        final file = File(testDbPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    });

    // Feature: finance-tracker, Property 20: Data persistence across app restarts
    test('Property 20: Data persists across database close and reopen', () async {
      // Generate random test data
      final testUser = User(
        name: 'Test User ${random.nextInt(1000)}',
        email: 'test${random.nextInt(10000)}@example.com',
        password: 'password${random.nextInt(1000)}',
        createdAt: DateTime.now(),
      );

      final testCategory = Category(
        userId: 1, // Will be updated after user creation
        name: 'Category ${random.nextInt(1000)}',
        createdAt: DateTime.now(),
      );

      final testTransaction = app_models.Transaction(
        userId: 1, // Will be updated after user creation
        type: random.nextBool() ? TransactionType.income : TransactionType.expense,
        amount: random.nextDouble() * 1000,
        description: 'Transaction ${random.nextInt(1000)}',
        categoryId: 1, // Will be updated after category creation
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Phase 1: Create database and insert data
      Database db = await openDatabase(
        testDbPath,
        version: 1,
        onCreate: (db, version) async {
          await DatabaseHelper.instance.createTables(db);
        },
      );

      // Insert user
      final userId = await db.insert('users', testUser.toMap());
      expect(userId, greaterThan(0));

      // Insert category with correct user_id
      final categoryWithUserId = Category(
        userId: userId,
        name: testCategory.name,
        createdAt: testCategory.createdAt,
      );
      final categoryId = await db.insert('categories', categoryWithUserId.toMap());
      expect(categoryId, greaterThan(0));

      // Insert transaction with correct user_id and category_id
      final transactionWithIds = app_models.Transaction(
        userId: userId,
        type: testTransaction.type,
        amount: testTransaction.amount,
        description: testTransaction.description,
        categoryId: categoryId,
        date: testTransaction.date,
        createdAt: testTransaction.createdAt,
      );
      final transactionId = await db.insert('transactions', transactionWithIds.toMap());
      expect(transactionId, greaterThan(0));

      // Close the database (simulating app restart)
      await db.close();

      // Phase 2: Reopen database and verify data persists
      db = await openDatabase(testDbPath);

      // Verify user persists
      final userResults = await db.query('users', where: 'id = ?', whereArgs: [userId]);
      expect(userResults.length, 1);
      final retrievedUser = User.fromMap(userResults.first);
      expect(retrievedUser.name, testUser.name);
      expect(retrievedUser.email, testUser.email);
      expect(retrievedUser.password, testUser.password);

      // Verify category persists
      final categoryResults = await db.query('categories', where: 'id = ?', whereArgs: [categoryId]);
      expect(categoryResults.length, 1);
      final retrievedCategory = Category.fromMap(categoryResults.first);
      expect(retrievedCategory.name, categoryWithUserId.name);
      expect(retrievedCategory.userId, userId);

      // Verify transaction persists
      final transactionResults = await db.query('transactions', where: 'id = ?', whereArgs: [transactionId]);
      expect(transactionResults.length, 1);
      final retrievedTransaction = app_models.Transaction.fromMap(transactionResults.first);
      expect(retrievedTransaction.userId, userId);
      expect(retrievedTransaction.type, transactionWithIds.type);
      expect(retrievedTransaction.amount, transactionWithIds.amount);
      expect(retrievedTransaction.description, transactionWithIds.description);
      expect(retrievedTransaction.categoryId, categoryId);

      // Close database
      await db.close();
    });

    // Run multiple iterations to test property across different random inputs
    for (int i = 0; i < 10; i++) {
      test('Property 20: Iteration ${i + 1} - Multiple entities persist', () async {
        final timestamp = DateTime.now().millisecondsSinceEpoch + i;
        final iterationDbPath = join(Directory.systemTemp.path, 'test_finance_iter_${timestamp}.db');

        try {
          // Create database
          Database db = await openDatabase(
            iterationDbPath,
            version: 1,
            onCreate: (db, version) async {
              await DatabaseHelper.instance.createTables(db);
            },
          );

          // Create multiple users
          final userCount = random.nextInt(5) + 1;
          final userIds = <int>[];
          for (int j = 0; j < userCount; j++) {
            final user = User(
              name: 'User $i-$j',
              email: 'user${i}_${j}_${random.nextInt(10000)}@test.com',
              password: 'pass$j',
              createdAt: DateTime.now(),
            );
            final id = await db.insert('users', user.toMap());
            userIds.add(id);
          }

          // Create categories for each user
          final categoryIds = <int>[];
          for (final userId in userIds) {
            final category = Category(
              userId: userId,
              name: 'Category for user $userId',
              createdAt: DateTime.now(),
            );
            final id = await db.insert('categories', category.toMap());
            categoryIds.add(id);
          }

          // Create transactions
          final transactionCount = random.nextInt(10) + 1;
          final transactionIds = <int>[];
          for (int j = 0; j < transactionCount; j++) {
            final userId = userIds[random.nextInt(userIds.length)];
            final categoryId = categoryIds[random.nextInt(categoryIds.length)];
            final transaction = app_models.Transaction(
              userId: userId,
              type: random.nextBool() ? TransactionType.income : TransactionType.expense,
              amount: random.nextDouble() * 1000,
              description: 'Transaction $j',
              categoryId: categoryId,
              date: DateTime.now(),
              createdAt: DateTime.now(),
            );
            final id = await db.insert('transactions', transaction.toMap());
            transactionIds.add(id);
          }

          // Close database
          await db.close();

          // Reopen and verify all data persists
          db = await openDatabase(iterationDbPath);

          // Verify user count
          final users = await db.query('users');
          expect(users.length, userCount);

          // Verify category count
          final categories = await db.query('categories');
          expect(categories.length, categoryIds.length);

          // Verify transaction count
          final transactions = await db.query('transactions');
          expect(transactions.length, transactionCount);

          // Close and cleanup
          await db.close();
          final file = File(iterationDbPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Cleanup on error
          final file = File(iterationDbPath);
          if (await file.exists()) {
            await file.delete();
          }
          rethrow;
        }
      });
    }
  });
}
