import 'package:intl/intl.dart';

/// Utility class for formatting data (currency, dates, etc.)
class Formatters {
  // Private constructor to prevent instantiation
  Formatters._();

  /// Currency symbol (configurable)
  static String currencySymbol = '\$';

  /// Formats a double amount as currency with 2 decimal places
  /// Example: 1234.5 -> "$1,234.50"
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Formats a date in a readable format
  /// Example: 2024-01-15 -> "Jan 15, 2024"
  static String formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  /// Formats a date with time in a readable format
  /// Example: 2024-01-15 14:30 -> "Jan 15, 2024 2:30 PM"
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy h:mm a');
    return formatter.format(dateTime);
  }

  /// Formats a date in short format
  /// Example: 2024-01-15 -> "01/15/24"
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('MM/dd/yy');
    return formatter.format(date);
  }

  /// Formats a date for display in lists (shows time if today, otherwise date)
  /// Example: Today -> "2:30 PM", Yesterday -> "Jan 14, 2024"
  static String formatDateSmart(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      // Show time if today
      final timeFormatter = DateFormat('h:mm a');
      return timeFormatter.format(date);
    } else {
      // Show date otherwise
      return formatDate(date);
    }
  }

  /// Sets the currency symbol for the app
  static void setCurrencySymbol(String symbol) {
    currencySymbol = symbol;
  }
}
