import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/category.dart';

/// Repository for managing Category data operations with SQLite
class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Creates a new category in the database
  /// Throws an exception if a category with the same name already exists for this user
  Future<Category> createCategory(Category category) async {
    try {
      final db = await _dbHelper.database;

      // Check if category name already exists for this user
      final existingCategories = await db.query(
        'categories',
        where: 'user_id = ? AND name = ?',
        whereArgs: [category.userId, category.name],
        limit: 1,
      );

      if (existingCategories.isNotEmpty) {
        throw Exception('A category with this name already exists. Please choose a different name.');
      }

      // Insert category and get the generated id
      final id = await db.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      // Return category with the generated id
      return Category(
        id: id,
        userId: category.userId,
        name: category.name,
        createdAt: category.createdAt,
      );
    } on DatabaseException catch (e) {
      // Check for constraint violations
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('constraint') || errorMsg.contains('unique')) {
        throw Exception('A category with this name already exists. Please choose a different name.');
      }
      throw Exception('Failed to create category. Please try again.');
    } catch (e) {
      if (e.toString().contains('already exists')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while creating the category. Please try again.');
    }
  }

  /// Retrieves all categories for a specific user
  Future<List<Category>> getCategoriesByUserId(int userId) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'categories',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'name ASC',
      );

      return results.map((map) => Category.fromMap(map)).toList();
    } on DatabaseException catch (e) {
      throw Exception('Failed to load categories. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading categories. Please try again.');
    }
  }

  /// Retrieves a specific category by id
  /// Returns null if category not found
  Future<Category?> getCategoryById(int id) async {
    try {
      final db = await _dbHelper.database;

      final results = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return Category.fromMap(results.first);
    } on DatabaseException catch (e) {
      throw Exception('Failed to retrieve category. Please try again.');
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Updates an existing category in the database
  /// This cascades to all transactions using this category
  Future<void> updateCategory(Category category) async {
    try {
      final db = await _dbHelper.database;

      final rowsAffected = await db.update(
        'categories',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Category not found. Unable to update.');
      }
    } on DatabaseException catch (e) {
      // Check for constraint violations
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('constraint') || errorMsg.contains('unique')) {
        throw Exception('A category with this name already exists. Please choose a different name.');
      }
      throw Exception('Failed to update category. Please try again.');
    } catch (e) {
      if (e.toString().contains('Category not found')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while updating. Please try again.');
    }
  }

  /// Deletes a category from the database
  /// Reassigns all transactions using this category to the default category
  Future<void> deleteCategory(int id) async {
    try {
      final db = await _dbHelper.database;

      // Get the category to find the user_id
      final category = await getCategoryById(id);
      if (category == null) {
        throw Exception('Category not found. Unable to delete.');
      }

      // Get or create default category for this user
      final defaultCategory = await getOrCreateDefaultCategory(category.userId);

      // Reassign all transactions from this category to the default category
      await db.update(
        'transactions',
        {'category_id': defaultCategory.id},
        where: 'category_id = ?',
        whereArgs: [id],
      );

      // Now delete the category
      final rowsAffected = await db.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Category not found. Unable to delete.');
      }
    } on DatabaseException catch (e) {
      // Check for constraint violations
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('constraint') || errorMsg.contains('foreign key')) {
        throw Exception('Cannot delete category. It is still in use by transactions.');
      }
      throw Exception('Failed to delete category. Please try again.');
    } catch (e) {
      if (e.toString().contains('Category not found')) {
        rethrow;
      }
      throw Exception('An unexpected error occurred while deleting. Please try again.');
    }
  }

  /// Gets or creates a default "Uncategorized" category for a user
  Future<Category> getOrCreateDefaultCategory(int userId) async {
    try {
      final db = await _dbHelper.database;

      // Try to find existing default category
      final results = await db.query(
        'categories',
        where: 'user_id = ? AND name = ?',
        whereArgs: [userId, 'Uncategorized'],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return Category.fromMap(results.first);
      }

      // Create default category if it doesn't exist
      final defaultCategory = Category(
        userId: userId,
        name: 'Uncategorized',
        createdAt: DateTime.now(),
      );

      return await createCategory(defaultCategory);
    } on DatabaseException catch (e) {
      throw Exception('Failed to create default category. Please try again.');
    } catch (e) {
      if (e.toString().contains('already exists')) {
        // If it already exists due to race condition, try to get it again
        final db = await _dbHelper.database;
        final results = await db.query(
          'categories',
          where: 'user_id = ? AND name = ?',
          whereArgs: [userId, 'Uncategorized'],
          limit: 1,
        );
        if (results.isNotEmpty) {
          return Category.fromMap(results.first);
        }
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
