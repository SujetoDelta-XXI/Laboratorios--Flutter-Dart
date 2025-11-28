import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/validators.dart';

/// Provider for managing authentication state
/// Handles user registration, login, logout, and session management
class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  /// Gets the currently authenticated user
  User? get currentUser => _currentUser;

  /// Gets the loading state
  bool get isLoading => _isLoading;

  /// Gets the last error message
  String? get errorMessage => _errorMessage;

  /// Registers a new user with validation
  /// Returns true if registration is successful, false otherwise
  /// Requirements: 1.2, 1.4, 1.5
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate input data
      final emailError = Validators.validateEmail(email);
      if (emailError != null) {
        _setError(emailError);
        return false;
      }

      final passwordError = Validators.validatePassword(password);
      if (passwordError != null) {
        _setError(passwordError);
        return false;
      }

      final nameError = Validators.validateRequired(name, 'Name');
      if (nameError != null) {
        _setError(nameError);
        return false;
      }

      // Create new user
      final newUser = User(
        name: name.trim(),
        email: email.trim(),
        password: password,
        createdAt: DateTime.now(),
      );

      // Save to database
      _currentUser = await _userRepository.createUser(newUser);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logs in a user with email and password
  /// Returns true if login is successful, false otherwise
  /// Requirements: 2.2, 2.3
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Authenticate user
      final user = await _userRepository.authenticateUser(email, password);

      if (user == null) {
        _setError('Invalid email or password');
        return false;
      }

      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logs out the current user and cleans up session data
  /// Requirements: 2.4
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
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
