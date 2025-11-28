import 'package:flutter_test/flutter_test.dart';
import 'package:ecoplus/utils/validators.dart';

void main() {
  group('Email Validation', () {
    test('validates correct email format', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('test.user@domain.co.uk'), isNull);
      expect(Validators.validateEmail('user+tag@example.com'), isNull);
    });

    test('rejects invalid email format', () {
      expect(Validators.validateEmail('invalid'), isNotNull);
      expect(Validators.validateEmail('user@'), isNotNull);
      expect(Validators.validateEmail('@example.com'), isNotNull);
      expect(Validators.validateEmail('user@domain'), isNotNull);
    });

    test('rejects empty or null email', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail('   '), isNotNull);
    });

    test('isValidEmail returns correct boolean', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('invalid'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
      expect(Validators.isValidEmail(null), isFalse);
    });
  });

  group('Password Validation', () {
    test('validates password with minimum 6 characters', () {
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('password'), isNull);
      expect(Validators.validatePassword('abcdefgh'), isNull);
    });

    test('rejects password shorter than 6 characters', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('abc'), isNotNull);
      expect(Validators.validatePassword('a'), isNotNull);
    });

    test('rejects empty or null password', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('isValidPassword returns correct boolean', () {
      expect(Validators.isValidPassword('123456'), isTrue);
      expect(Validators.isValidPassword('12345'), isFalse);
      expect(Validators.isValidPassword(''), isFalse);
      expect(Validators.isValidPassword(null), isFalse);
    });
  });

  group('Amount Validation', () {
    test('validates positive numbers', () {
      expect(Validators.validateAmount('100'), isNull);
      expect(Validators.validateAmount('0.01'), isNull);
      expect(Validators.validateAmount('1000.50'), isNull);
      expect(Validators.validateAmount('  50.25  '), isNull);
    });

    test('rejects zero and negative numbers', () {
      expect(Validators.validateAmount('0'), isNotNull);
      expect(Validators.validateAmount('-10'), isNotNull);
      expect(Validators.validateAmount('-0.01'), isNotNull);
    });

    test('rejects non-numeric values', () {
      expect(Validators.validateAmount('abc'), isNotNull);
      expect(Validators.validateAmount('12.34.56'), isNotNull);
      expect(Validators.validateAmount('\$100'), isNotNull);
    });

    test('rejects empty or null amount', () {
      expect(Validators.validateAmount(''), isNotNull);
      expect(Validators.validateAmount(null), isNotNull);
      expect(Validators.validateAmount('   '), isNotNull);
    });

    test('isValidAmount returns correct boolean for double values', () {
      expect(Validators.isValidAmount(100.0), isTrue);
      expect(Validators.isValidAmount(0.01), isTrue);
      expect(Validators.isValidAmount(0.0), isFalse);
      expect(Validators.isValidAmount(-10.0), isFalse);
      expect(Validators.isValidAmount(null), isFalse);
    });
  });

  group('Required Field Validation', () {
    test('validates non-empty fields', () {
      expect(Validators.validateRequired('John Doe', 'Name'), isNull);
      expect(Validators.validateRequired('Some text', 'Description'), isNull);
    });

    test('rejects empty or null fields', () {
      expect(Validators.validateRequired('', 'Name'), isNotNull);
      expect(Validators.validateRequired(null, 'Name'), isNotNull);
      expect(Validators.validateRequired('   ', 'Name'), isNotNull);
    });

    test('includes field name in error message', () {
      final error = Validators.validateRequired('', 'Username');
      expect(error, contains('Username'));
    });
  });
}
