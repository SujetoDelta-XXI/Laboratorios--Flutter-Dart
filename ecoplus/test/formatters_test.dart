import 'package:flutter_test/flutter_test.dart';
import 'package:ecoplus/utils/formatters.dart';

void main() {
  group('Currency Formatting', () {
    test('formats currency with 2 decimal places', () {
      expect(Formatters.formatCurrency(1234.5), '\$1,234.50');
      expect(Formatters.formatCurrency(100.0), '\$100.00');
      expect(Formatters.formatCurrency(0.99), '\$0.99');
    });

    test('formats negative currency correctly', () {
      expect(Formatters.formatCurrency(-50.25), '-\$50.25');
    });

    test('formats zero correctly', () {
      expect(Formatters.formatCurrency(0.0), '\$0.00');
    });

    test('formats large amounts correctly', () {
      expect(Formatters.formatCurrency(1000000.00), '\$1,000,000.00');
    });

    test('respects custom currency symbol', () {
      Formatters.setCurrencySymbol('€');
      expect(Formatters.formatCurrency(100.0), '€100.00');
      
      // Reset to default
      Formatters.setCurrencySymbol('\$');
    });
  });

  group('Date Formatting', () {
    test('formats date in readable format', () {
      final date = DateTime(2024, 1, 15);
      expect(Formatters.formatDate(date), 'Jan 15, 2024');
    });

    test('formats date with time', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30);
      expect(Formatters.formatDateTime(dateTime), 'Jan 15, 2024 2:30 PM');
    });

    test('formats date in short format', () {
      final date = DateTime(2024, 1, 15);
      expect(Formatters.formatDateShort(date), '01/15/24');
    });

    test('formats today\'s date with time only', () {
      final now = DateTime.now();
      final result = Formatters.formatDateSmart(now);
      
      // Should contain time format (AM or PM)
      expect(result.contains('AM') || result.contains('PM'), isTrue);
    });

    test('formats past date with date only', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final result = Formatters.formatDateSmart(yesterday);
      
      // Should not contain time format
      expect(result.contains('AM') || result.contains('PM'), isFalse);
      // Should contain month abbreviation
      expect(result.length, greaterThan(5));
    });
  });

  group('Currency Symbol Configuration', () {
    test('can set and use different currency symbols', () {
      // Test with Euro
      Formatters.setCurrencySymbol('€');
      expect(Formatters.formatCurrency(50.0), '€50.00');
      
      // Test with Pound
      Formatters.setCurrencySymbol('£');
      expect(Formatters.formatCurrency(50.0), '£50.00');
      
      // Test with Yen
      Formatters.setCurrencySymbol('¥');
      expect(Formatters.formatCurrency(50.0), '¥50.00');
      
      // Reset to default
      Formatters.setCurrencySymbol('\$');
      expect(Formatters.formatCurrency(50.0), '\$50.00');
    });
  });
}
