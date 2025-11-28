import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../repositories/category_repository.dart';

/// Provider for managing category state
/// Handles category CRUD operations with uniqueness validation
class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();
  
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Gets the list of categories
  List<Category> get categories => List.unmodifiable(_categories);

  /// Gets the loading state
  bool get isLoading => _isLoading;

  /// Gets the last error message
  String? get errorMessage => _errorMessage;

  /// Loads all categories for a user
  /// Requirements: 8.1
  Future<void> loadCategories(int userId) async {
    _setLoading(true);
    _clearError();

    try {
      _categories = await _categoryRepository.getCategoriesByUserId(userId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds a new category with uniqueness validation
  /// Requirements: 8.2, 8.3
  Future<bool> addCategory(Category category) async {
    _setLoading(true);
    _clearError();

    try {
      // Check for duplicate name (validation happens in repository)
      final createdCategory = await _categoryRepository.createCategory(category);
      
      // Add to local list
      _categories.add(createdCategory);
      
      // Sort categories by name
      _categories.sort((a, b) => a.name.compareTo(b.name));
      
      notifyListeners();
      return true;
    } catch (e) {
      if (e.toString().contains('already exists')) {
        _setError('A category with this name already exists');
      } else {
        _setError('Failed to add category: ${e.toString()}');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates an existing category
  /// Requirements: 8.4
  Future<bool> updateCategory(Category category) async {
    _setLoading(true);
    _clearError();

    try {
      await _categoryRepository.updateCategory(category);
      
      // Update in local list
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
      
      // Sort categories by name
      _categories.sort((a, b) => a.name.compareTo(b.name));
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update category: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes a category
  /// Transactions using this category will be reassigned to default category
  /// Requirements: 8.5
  Future<bool> deleteCategory(int categoryId) async {
    _setLoading(true);
    _clearError();

    try {
      await _categoryRepository.deleteCategory(categoryId);
      
      // Remove from local list
      _categories.removeWhere((c) => c.id == categoryId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete category: ${e.toString()}');
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
