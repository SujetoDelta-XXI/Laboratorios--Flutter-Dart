import 'package:sqflite/sqflite.dart' hide Transaction;
import '../database/database_helper.dart';
import '../models/transaction.dart';

/// Repository for managing Transaction data operations with SQLite
class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Creates a new transaction in the database
  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final db = await _dbHelper.database;

      // Insert transaction and get the generated id
      final id = await db.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      // Return transaction with the generated id
      return Transaction(
        id: id,
        userId: transaction.userId,
        type: transaction.type,
        amount: transaction.amount,
        description: transaction.description,
        categoryId: transaction.categoryId,
        date: transaction.date,
        createdAt: transaction.createdAt,
      );
    } on DatabaseException catch (e) {
      // Check for constraint violations (e.g., foreign key, check constraints)
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('constraint') || errorMsg.contains('foreign key')) {
        throw Exception('Invalid transaction data. Please check the amount and category.');
      }
      throw Exception('Failed to save transaction. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while saving the transaction. Please try again.');
    }
  }

  /// Retrieves all transactions for a specific user, ordered by date descending
  Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );

      return results.map((map) => Transaction.fromMap(map)).toList();
    } on DatabaseException catch (e) {
      throw Exception('Failed to load transactions. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading transactions. Please try again.');
    }
  }

  /// Retrieves transactions for a specific user with pagination support
  /// [limit] - Maximum number of transactions to retrieve
  /// [offset] - Number of transactions to skip (for pagination)
  Future<List<Transaction>> getTransactionsByUserIdPaginated(
    int userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
        limit: limit,
        offset: offset,
      );

      return results.map((map) => Transaction.fromMap(map)).toList();
    } on DatabaseException catch (e) {
      throw Exception('Failed to load transactions. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading transactions. Please try again.');
    }
  }

  /// Gets the total count of transactions for a user
  Future<int> getTransactionCount(int userId) async {
    try {
      final db = await _dbHelper.database;

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM transactions WHERE user_id = ?',
        [userId],
      );

      return result.first['count'] as int? ?? 0;
    } on DatabaseException catch (e) {
      throw Exception('Failed to count transactions. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Retrieves a specific transaction by id
  /// Returns null if transaction not found
  Future<Transaction?> getTransactionById(int id) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return Transaction.fromMap(results.first);
    } on DatabaseException catch (e) {
      throw Exception('Failed to retrieve transaction. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Updates an existing transaction in the database
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final db = await _dbHelper.database;

      final rowsAffected = await db.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Transaction not found. Unable to update.');
      }
    } on DatabaseException catch (e) {
      // Check for constraint violations
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('constraint') || errorMsg.contains('foreign key')) {
        throw Exception('Invalid transaction data. Please check the amount and category.');
      }
      throw Exception('Failed to update transaction. Please try again.');
    } catch (e) {
      if (e.toString().contains('Transaction not found')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while updating. Please try again.');
    }
  }

  /// Deletes a transaction from the database
  Future<void> deleteTransaction(int id) async {
    try {
      final db = await _dbHelper.database;

      final rowsAffected = await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Transaction not found. Unable to delete.');
      }
    } on DatabaseException catch (e) {
      throw Exception('Failed to delete transaction. Please try again.');
    } catch (e) {
      if (e.toString().contains('Transaction not found')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while deleting. Please try again.');
    }
  }

  /// Calculates the balance for a user (sum of incomes - sum of expenses)
  /// Optimized to use a single query with conditional aggregation
  Future<double> calculateBalance(int userId) async {
    try {
      final db = await _dbHelper.database;

      // Optimized: Calculate both sums in a single query using CASE
      final result = await db.rawQuery('''
        SELECT 
          COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0.0) as income_total,
          COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0.0) as expense_total
        FROM transactions 
        WHERE user_id = ?
      ''', [userId]);

      final incomeTotal = (result.first['income_total'] as num?)?.toDouble() ?? 0.0;
      final expenseTotal = (result.first['expense_total'] as num?)?.toDouble() ?? 0.0;

      // Return balance (incomes - expenses)
      return incomeTotal - expenseTotal;
    } on DatabaseException catch (e) {
      throw Exception('Failed to calculate balance. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while calculating balance. Please try again.');
    }
  }
}
