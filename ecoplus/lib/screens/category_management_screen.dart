import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../widgets/category_list_item.dart';
import '../widgets/confirmation_dialog.dart';
import '../utils/user_feedback.dart';

/// Screen for managing categories
/// Requirements: 8.1, 8.2, 8.3, 8.4, 8.5
class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  void _showCategoryDialog({Category? category}) {
    final isEditMode = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditMode ? 'Editar Categoría' : 'Nueva Categoría'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la categoría',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                final userId = authProvider.currentUser?.id;

                if (userId == null) return;

                final newCategory = Category(
                  id: isEditMode ? category.id : null,
                  userId: userId,
                  name: nameController.text.trim(),
                  createdAt: isEditMode ? category.createdAt : DateTime.now(),
                );

                bool success;
                if (isEditMode) {
                  success = await categoryProvider.updateCategory(newCategory);
                } else {
                  success = await categoryProvider.addCategory(newCategory);
                }

                if (!context.mounted) return;

                Navigator.of(context).pop();

                if (success) {
                  UserFeedback.showSuccess(
                    isEditMode
                        ? 'Categoría actualizada exitosamente'
                        : 'Categoría creada exitosamente',
                  );
                } else {
                  final errorMessage = categoryProvider.errorMessage ?? 'Error al guardar la categoría';
                  UserFeedback.showErrorDialog(
                    context,
                    'Error',
                    errorMessage,
                  );
                }
              }
            },
            child: Text(isEditMode ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Category category) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Confirmar eliminación',
      message: '¿Estás seguro de que deseas eliminar la categoría "${category.name}"?\n\n'
          'Las transacciones asociadas serán reasignadas a la categoría predeterminada.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      confirmColor: Colors.red,
    );

    if (!confirmed || !mounted) return;

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final success = await categoryProvider.deleteCategory(category.id!);

    if (!mounted) return;

    if (success) {
      UserFeedback.showSuccess('Categoría eliminada exitosamente');
    } else {
      final errorMessage = categoryProvider.errorMessage ?? 'Error al eliminar la categoría';
      UserFeedback.showErrorDialog(
        context,
        'Error',
        errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Categorías'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categoryProvider.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay categorías',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu primera categoría',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              
              return CategoryListItem(
                category: category,
                onEdit: () => _showCategoryDialog(category: category),
                onDelete: () => _showDeleteConfirmation(category),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
