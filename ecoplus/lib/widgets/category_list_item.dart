import 'package:flutter/material.dart';
import '../models/category.dart';

/// Reusable widget for displaying a category with edit and delete actions
/// Requirements: 8.1
class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          child: Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}
