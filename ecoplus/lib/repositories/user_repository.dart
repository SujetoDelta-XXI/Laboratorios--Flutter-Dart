import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

/// Repository for managing User data operations with SQLite
class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Creates a new user in the database
  /// Throws an exception if email already exists
  Future<User> createUser(User user) async {
    try {
      final db = await _dbHelper.database;

      // Check if email already exists
      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null) {
        throw Exception('This email is already registered. Please use a different email or login.');
      }

      // Insert user and get the generated id
      final id = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      // Return user with the generated id
      return User(
        id: id,
        name: user.name,
        email: user.email,
        password: user.password,
        createdAt: user.createdAt,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('This email is already registered. Please use a different email or login.');
      }
      throw Exception('Failed to create account. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while creating your account. Please try again.');
    }
  }

  /// Retrieves a user by email address
  /// Returns null if user not found
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return User.fromMap(results.first);
    } on DatabaseException catch (e) {
      throw Exception('Failed to retrieve user information. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Authenticates a user with email and password
  /// Returns the user if credentials are valid, null otherwise
  Future<User?> authenticateUser(String email, String password) async {
    try {
      final user = await getUserByEmail(email);

      if (user == null) {
        return null;
      }

      // Verify password
      if (user.password == password) {
        return user;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to authenticate. Please try again.');
    }
  }

  /// Updates an existing user in the database
  Future<void> updateUser(User user) async {
    try {
      final db = await _dbHelper.database;

      final rowsAffected = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (rowsAffected == 0) {
        throw Exception('User not found. Unable to update.');
      }
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('This email is already in use by another account.');
      }
      throw Exception('Failed to update user information. Please try again.');
    } catch (e) {
      if (e.toString().contains('User not found')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while updating. Please try again.');
    }
  }
}
