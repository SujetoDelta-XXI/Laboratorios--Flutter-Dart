import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'dart:io';

import 'package:ecoplus/database/database_helper.dart';
import 'package:ecoplus/repositories/user_repository.dart';
import 'package:ecoplus/repositories/transaction_repository.dart';
import 'package:ecoplus/repositories/category_repository.dart';
import 'package:ecoplus/models/user.dart';
import 'package:ecoplus/models/category.dart';
import 'package:ecoplus/models/transaction.dart' as app_models;
import 'package:ecoplus/models/transaction_type.dart';
import 'dart:math';

void main() {
  // Initialize FFI for testing
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Performance Tests', () {
    late UserRepository userRepo;
    late TransactionRepository transactionRepo;
    late CategoryRepository categoryRepo;
    final random = Random();

    setUp(() async {
      // Close any existing database connection
      try {
        await DatabaseHelper.instance.close();
      } catch (e) {
        // Ignore if no database is open
      }

      // Initialize repositories
      userRepo = UserRepository();
      transactionRepo = TransactionRepository();
      categoryRepo = CategoryRepository();
    });

    tearDown(() async {
      // Clean up test database
      try {
        await DatabaseHelper.instance.close();

        // Delete the actual database file used by DatabaseHelper
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'finance_tracker.db');
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    });

    test('Balance calculation performance with optimized query', () async {
      // Create test user
      final user = User(
        name: 'Performance Test User',
        email: 'perf@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);

      // Create category
      final category = Category(
        userId: createdUser.id!,
        name: 'Test Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);

      // Create 100 transactions
      for (int i = 0; i < 100; i++) {
        final transaction = app_models.Transaction(
          userId: createdUser.id!,
          type: random.nextBool() ? TransactionType.income : TransactionType.expense,
          amount: random.nextDouble() * 1000,
          description: 'Transaction $i',
          categoryId: createdCategory.id!,
          date: DateTime.now().subtract(Duration(days: i)),
          createdAt: DateTime.now(),
        );
        await transactionRepo.createTransaction(transaction);
      }

      // Measure balance calculation time
      final stopwatch = Stopwatch()..start();
      final balance = await transactionRepo.calculateBalance(createdUser.id!);
      stopwatch.stop();

      print('Balance calculation time for 100 transactions: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast
      expect(balance, isA<double>());
    });

    test('Pagination performance with large dataset', () async {
      // Create test user
      final user = User(
        name: 'Pagination Test User',
        email: 'pagination@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);

      // Create category
      final category = Category(
        userId: createdUser.id!,
        name: 'Test Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);

      // Create 200 transactions
      for (int i = 0; i < 200; i++) {
        final transaction = app_models.Transaction(
          userId: createdUser.id!,
          type: random.nextBool() ? TransactionType.income : TransactionType.expense,
          amount: random.nextDouble() * 1000,
          description: 'Transaction $i',
          categoryId: createdCategory.id!,
          date: DateTime.now().subtract(Duration(days: i)),
          createdAt: DateTime.now(),
        );
        await transactionRepo.createTransaction(transaction);
      }

      // Test pagination
      final stopwatch = Stopwatch()..start();
      final page1 = await transactionRepo.getTransactionsByUserIdPaginated(
        createdUser.id!,
        limit: 50,
        offset: 0,
      );
      stopwatch.stop();

      print('First page load time (50 of 200 transactions): ${stopwatch.elapsedMilliseconds}ms');
      expect(page1.length, 50);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));

      // Load second page
      final page2 = await transactionRepo.getTransactionsByUserIdPaginated(
        createdUser.id!,
        limit: 50,
        offset: 50,
      );
      expect(page2.length, 50);

      // Verify pagination works correctly (no overlap)
      final page1Ids = page1.map((t) => t.id).toSet();
      final page2Ids = page2.map((t) => t.id).toSet();
      expect(page1Ids.intersection(page2Ids).isEmpty, isTrue);
    });

    test('Transaction count query performance', () async {
      // Create test user
      final user = User(
        name: 'Count Test User',
        email: 'count@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);

      // Create category
      final category = Category(
        userId: createdUser.id!,
        name: 'Test Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);

      // Create 150 transactions
      for (int i = 0; i < 150; i++) {
        final transaction = app_models.Transaction(
          userId: createdUser.id!,
          type: random.nextBool() ? TransactionType.income : TransactionType.expense,
          amount: random.nextDouble() * 1000,
          description: 'Transaction $i',
          categoryId: createdCategory.id!,
          date: DateTime.now().subtract(Duration(days: i)),
          createdAt: DateTime.now(),
        );
        await transactionRepo.createTransaction(transaction);
      }

      // Measure count query time
      final stopwatch = Stopwatch()..start();
      final count = await transactionRepo.getTransactionCount(createdUser.id!);
      stopwatch.stop();

      print('Transaction count query time for 150 transactions: ${stopwatch.elapsedMilliseconds}ms');
      expect(count, 150);
      expect(stopwatch.elapsedMilliseconds, lessThan(50)); // Should be very fast
    });

    test('Index effectiveness on date-ordered queries', () async {
      // Create test user
      final user = User(
        name: 'Index Test User',
        email: 'index@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);

      // Create category
      final category = Category(
        userId: createdUser.id!,
        name: 'Test Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);

      // Create 300 transactions with varying dates
      for (int i = 0; i < 300; i++) {
        final transaction = app_models.Transaction(
          userId: createdUser.id!,
          type: random.nextBool() ? TransactionType.income : TransactionType.expense,
          amount: random.nextDouble() * 1000,
          description: 'Transaction $i',
          categoryId: createdCategory.id!,
          date: DateTime.now().subtract(Duration(days: random.nextInt(365))),
          createdAt: DateTime.now(),
        );
        await transactionRepo.createTransaction(transaction);
      }

      // Measure query time with date ordering (should use index)
      final stopwatch = Stopwatch()..start();
      final transactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      stopwatch.stop();

      print('Date-ordered query time for 300 transactions: ${stopwatch.elapsedMilliseconds}ms');
      expect(transactions.length, 300);
      expect(stopwatch.elapsedMilliseconds, lessThan(150));

      // Verify transactions are ordered by date descending
      for (int i = 0; i < transactions.length - 1; i++) {
        expect(
          transactions[i].date.isAfter(transactions[i + 1].date) ||
              transactions[i].date.isAtSameMomentAs(transactions[i + 1].date),
          isTrue,
          reason: 'Transactions should be ordered by date descending',
        );
      }
    });
  });
}
