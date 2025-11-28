import 'package:flutter/material.dart';
import '../models/transaction.dart' as model;
import '../models/transaction_type.dart';
import '../models/category.dart';
import '../utils/formatters.dart';

/// Reusable widget for displaying a transaction in a card format
/// Requirements: 5.2, 5.3
class TransactionCard extends StatelessWidget {
  final model.Transaction transaction;
  final Category category;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${category.name} • ${Formatters.formatDate(transaction.date)}',
        ),
        trailing: Text(
          Formatters.formatCurrency(transaction.amount),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
