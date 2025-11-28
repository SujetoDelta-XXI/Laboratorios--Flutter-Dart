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

void main() {
  // Initialize FFI for testing
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Integration Tests - Complete User Flows', () {
    late String testDbPath;
    late UserRepository userRepo;
    late TransactionRepository transactionRepo;
    late CategoryRepository categoryRepo;

    setUp(() async {
      // Create a unique test database path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      testDbPath = join(Directory.systemTemp.path, 'test_integration_$timestamp.db');
      
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

    test('Complete flow: registration → login → add transaction → view balance', () async {
      // Step 1: Register a new user
      final newUser = User(
        name: 'Integration Test User',
        email: 'integration@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      
      final createdUser = await userRepo.createUser(newUser);
      expect(createdUser.id, isNotNull);
      expect(createdUser.email, newUser.email);
      
      // Step 2: Login (authenticate user)
      final authenticatedUser = await userRepo.authenticateUser(
        'integration@test.com',
        'password123',
      );
      expect(authenticatedUser, isNotNull);
      expect(authenticatedUser!.id, createdUser.id);
      
      // Step 3: Create a default category
      final category = Category(
        userId: createdUser.id!,
        name: 'Salary',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);
      expect(createdCategory.id, isNotNull);
      
      // Step 4: Add an income transaction
      final incomeTransaction = app_models.Transaction(
        userId: createdUser.id!,
        type: TransactionType.income,
        amount: 5000.00,
        description: 'Monthly salary',
        categoryId: createdCategory.id!,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      final createdIncome = await transactionRepo.createTransaction(incomeTransaction);
      expect(createdIncome.id, isNotNull);
      expect(createdIncome.amount, 5000.00);
      
      // Step 5: Add an expense transaction
      final expenseCategory = Category(
        userId: createdUser.id!,
        name: 'Groceries',
        createdAt: DateTime.now(),
      );
      final createdExpenseCategory = await categoryRepo.createCategory(expenseCategory);
      
      final expenseTransaction = app_models.Transaction(
        userId: createdUser.id!,
        type: TransactionType.expense,
        amount: 150.50,
        description: 'Weekly groceries',
        categoryId: createdExpenseCategory.id!,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      final createdExpense = await transactionRepo.createTransaction(expenseTransaction);
      expect(createdExpense.id, isNotNull);
      
      // Step 6: View balance
      final balance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(balance, 4849.50); // 5000.00 - 150.50
      
      // Step 7: Verify transaction list
      final transactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      expect(transactions.length, 2);
      expect(transactions[0].date.isAfter(transactions[1].date) || 
             transactions[0].date.isAtSameMomentAs(transactions[1].date), isTrue);
    });

    test('Complete flow: category creation → transaction with category', () async {
      // Step 1: Create user
      final user = User(
        name: 'Category Test User',
        email: 'category@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);
      
      // Step 2: Create multiple categories
      final categories = [
        Category(userId: createdUser.id!, name: 'Food', createdAt: DateTime.now()),
        Category(userId: createdUser.id!, name: 'Transport', createdAt: DateTime.now()),
        Category(userId: createdUser.id!, name: 'Entertainment', createdAt: DateTime.now()),
      ];
      
      final createdCategories = <Category>[];
      for (final category in categories) {
        final created = await categoryRepo.createCategory(category);
        createdCategories.add(created);
      }
      
      expect(createdCategories.length, 3);
      
      // Step 3: Create transactions for each category
      for (final category in createdCategories) {
        final transaction = app_models.Transaction(
          userId: createdUser.id!,
          type: TransactionType.expense,
          amount: 50.00,
          description: 'Test expense for ${category.name}',
          categoryId: category.id!,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        );
        
        final created = await transactionRepo.createTransaction(transaction);
        expect(created.categoryId, category.id);
      }
      
      // Step 4: Verify all transactions were created
      final allTransactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      expect(allTransactions.length, 3);
      
      // Step 5: Verify categories list
      final allCategories = await categoryRepo.getCategoriesByUserId(createdUser.id!);
      expect(allCategories.length, 3);
    });

    test('Complete flow: edit and delete transactions', () async {
      // Step 1: Create user and category
      final user = User(
        name: 'Edit Test User',
        email: 'edit@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);
      
      final category = Category(
        userId: createdUser.id!,
        name: 'Test Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);
      
      // Step 2: Create a transaction
      final transaction = app_models.Transaction(
        userId: createdUser.id!,
        type: TransactionType.income,
        amount: 1000.00,
        description: 'Original description',
        categoryId: createdCategory.id!,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      final createdTransaction = await transactionRepo.createTransaction(transaction);
      final originalBalance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(originalBalance, 1000.00);
      
      // Step 3: Edit the transaction
      final updatedTransaction = app_models.Transaction(
        id: createdTransaction.id,
        userId: createdUser.id!,
        type: TransactionType.income,
        amount: 1500.00, // Changed amount
        description: 'Updated description', // Changed description
        categoryId: createdCategory.id!,
        date: createdTransaction.date,
        createdAt: createdTransaction.createdAt,
      );
      
      await transactionRepo.updateTransaction(updatedTransaction);
      
      // Step 4: Verify the update
      final retrievedTransaction = await transactionRepo.getTransactionById(createdTransaction.id!);
      expect(retrievedTransaction, isNotNull);
      expect(retrievedTransaction!.amount, 1500.00);
      expect(retrievedTransaction.description, 'Updated description');
      
      final updatedBalance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(updatedBalance, 1500.00);
      
      // Step 5: Delete the transaction
      await transactionRepo.deleteTransaction(createdTransaction.id!);
      
      // Step 6: Verify deletion
      final deletedTransaction = await transactionRepo.getTransactionById(createdTransaction.id!);
      expect(deletedTransaction, isNull);
      
      final finalBalance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(finalBalance, 0.00);
      
      final transactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      expect(transactions.length, 0);
    });

    test('Complete flow: offline functionality (all operations use SQLite)', () async {
      // This test verifies that all operations work without network connectivity
      // by using only SQLite local storage
      
      // Step 1: Create user offline
      final user = User(
        name: 'Offline User',
        email: 'offline@test.com',
        password: 'password123',
        createdAt: DateTime.now(),
      );
      final createdUser = await userRepo.createUser(user);
      expect(createdUser.id, isNotNull);
      
      // Step 2: Create category offline
      final category = Category(
        userId: createdUser.id!,
        name: 'Offline Category',
        createdAt: DateTime.now(),
      );
      final createdCategory = await categoryRepo.createCategory(category);
      expect(createdCategory.id, isNotNull);
      
      // Step 3: Create transaction offline
      final transaction = app_models.Transaction(
        userId: createdUser.id!,
        type: TransactionType.expense,
        amount: 75.00,
        description: 'Offline transaction',
        categoryId: createdCategory.id!,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      final createdTransaction = await transactionRepo.createTransaction(transaction);
      expect(createdTransaction.id, isNotNull);
      
      // Step 4: Read data offline
      final retrievedUser = await userRepo.getUserByEmail('offline@test.com');
      expect(retrievedUser, isNotNull);
      expect(retrievedUser!.name, 'Offline User');
      
      final categories = await categoryRepo.getCategoriesByUserId(createdUser.id!);
      expect(categories.length, 1);
      
      final transactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      expect(transactions.length, 1);
      
      final balance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(balance, -75.00);
      
      // Step 5: Update data offline
      final updatedTransaction = app_models.Transaction(
        id: createdTransaction.id,
        userId: createdUser.id!,
        type: TransactionType.income,
        amount: 200.00,
        description: 'Updated offline',
        categoryId: createdCategory.id!,
        date: createdTransaction.date,
        createdAt: createdTransaction.createdAt,
      );
      await transactionRepo.updateTransaction(updatedTransaction);
      
      final newBalance = await transactionRepo.calculateBalance(createdUser.id!);
      expect(newBalance, 200.00);
      
      // Step 6: Delete data offline
      await transactionRepo.deleteTransaction(createdTransaction.id!);
      final finalTransactions = await transactionRepo.getTransactionsByUserId(createdUser.id!);
      expect(finalTransactions.length, 0);
    });
  });
}
