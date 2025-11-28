/// Validation utilities for the Finance Tracker application
/// Provides validation functions for email, password, amount, and required fields

class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Email validation regex pattern
  /// Validates standard email format: username@domain.extension
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates email format
  /// Returns null if valid, error message if invalid
  /// Requirements: 1.4
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password length (minimum 6 characters)
  /// Returns null if valid, error message if invalid
  /// Requirements: 1.4
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  /// Validates amount (must be positive number)
  /// Returns null if valid, error message if invalid
  /// Requirements: 3.3, 4.3
  static String? validateAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 'Amount is required';
    }

    final double? parsedAmount = double.tryParse(amount.trim());

    if (parsedAmount == null) {
      return 'Please enter a valid number';
    }

    if (parsedAmount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  /// Validates that a required field is not empty
  /// Returns null if valid, error message if invalid
  /// Requirements: 1.4, 3.3, 4.3
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  /// Validates amount as a double value (for programmatic use)
  /// Returns true if valid, false otherwise
  /// Requirements: 3.3, 4.3
  static bool isValidAmount(double? amount) {
    return amount != null && amount > 0;
  }

  /// Validates email format (boolean version for programmatic use)
  /// Returns true if valid, false otherwise
  /// Requirements: 1.4
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates password length (boolean version for programmatic use)
  /// Returns true if valid, false otherwise
  /// Requirements: 1.4
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    return password.length >= 6;
  }
}
