import 'package:flutter/foundation.dart';
import '../models/transaction.dart' as model;
import '../repositories/transaction_repository.dart';

/// Provider for managing transaction state
/// Handles transaction CRUD operations and balance calculation
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _transactionRepository = TransactionRepository();
  
  List<model.Transaction> _transactions = [];
  double _balance = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  /// Gets the list of transactions
  List<model.Transaction> get transactions => List.unmodifiable(_transactions);

  /// Gets the current balance
  double get balance => _balance;

  /// Gets the loading state
  bool get isLoading => _isLoading;

  /// Gets the last error message
  String? get errorMessage => _errorMessage;

  /// Loads all transactions for a user and calculates balance
  /// Requirements: 5.1, 9.1
  Future<void> loadTransactions(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _transactions = await _transactionRepository.getTransactionsByUserId(userId);
      _balance = await _transactionRepository.calculateBalance(userId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load transactions: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds a new transaction
  /// Requirements: 3.2, 4.2, 6.5
  Future<bool> addTransaction(model.Transaction transaction) async {
    _setLoading(true);
    _clearError();

    try {
      final createdTransaction = await _transactionRepository.createTransaction(transaction);
      
      // Add to local list
      _transactions.insert(0, createdTransaction);
      
      // Recalculate balance
      _balance = await _transactionRepository.calculateBalance(transaction.userId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add transaction: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates an existing transaction
  /// Requirements: 6.2, 6.3, 6.5
  Future<bool> updateTransaction(model.Transaction transaction) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionRepository.updateTransaction(transaction);
      
      // Update in local list
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      
      // Recalculate balance
      _balance = await _transactionRepository.calculateBalance(transaction.userId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update transaction: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes a transaction
  /// Requirements: 7.2, 7.3, 7.5
  Future<bool> deleteTransaction(int transactionId, int userId) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionRepository.deleteTransaction(transactionId);
      
      // Remove from local list
      _transactions.removeWhere((t) => t.id == transactionId);
      
      // Recalculate balance
      _balance = await _transactionRepository.calculateBalance(userId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete transaction: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sets loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets error message and notifies listeners
  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Clears error message
  void _clearError() {
    _errorMessage = null;
  }
}
