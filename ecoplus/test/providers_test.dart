import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ecoplus/providers/auth_provider.dart';
import 'package:ecoplus/providers/transaction_provider.dart';
import 'package:ecoplus/providers/category_provider.dart';
import 'package:ecoplus/models/transaction.dart' as model;
import 'package:ecoplus/models/transaction_type.dart';
import 'package:ecoplus/models/category.dart';

void main() {
  // Initialize FFI for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Provider Instantiation Tests', () {
    test('AuthProvider can be instantiated', () {
      final authProvider = AuthProvider();
      expect(authProvider, isNotNull);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, isFalse);
    });

    test('TransactionProvider can be instantiated', () {
      final transactionProvider = TransactionProvider();
      expect(transactionProvider, isNotNull);
      expect(transactionProvider.transactions, isEmpty);
      expect(transactionProvider.balance, equals(0.0));
      expect(transactionProvider.isLoading, isFalse);
    });

    test('CategoryProvider can be instantiated', () {
      final categoryProvider = CategoryProvider();
      expect(categoryProvider, isNotNull);
      expect(categoryProvider.categories, isEmpty);
      expect(categoryProvider.isLoading, isFalse);
    });
  });

  group('AuthProvider Basic Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    test('register with invalid email should fail', () async {
      final result = await authProvider.register('Test User', 'invalid-email', 'password123');
      expect(result, isFalse);
      expect(authProvider.errorMessage, isNotNull);
      expect(authProvider.currentUser, isNull);
    });

    test('register with short password should fail', () async {
      final result = await authProvider.register('Test User', 'test@example.com', '12345');
      expect(result, isFalse);
      expect(authProvider.errorMessage, isNotNull);
      expect(authProvider.currentUser, isNull);
    });

    test('register with empty name should fail', () async {
      final result = await authProvider.register('', 'test@example.com', 'password123');
      expect(result, isFalse);
      expect(authProvider.errorMessage, isNotNull);
      expect(authProvider.currentUser, isNull);
    });

    test('logout clears current user', () {
      authProvider.logout();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.isLoading, isFalse);
    });
  });
}
