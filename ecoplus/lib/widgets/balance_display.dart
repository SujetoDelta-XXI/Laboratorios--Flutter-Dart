import 'package:flutter/material.dart';
import '../utils/formatters.dart';

/// Reusable widget for displaying the balance with color coding
/// Requirements: 9.1, 9.2, 9.3, 9.5
class BalanceDisplay extends StatelessWidget {
  final double balance;

  const BalanceDisplay({
    super.key,
    required this.balance,
  });

  Color _getBalanceColor() {
    if (balance > 0) return Colors.green;
    if (balance < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Balance Total',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(balance),
            style: TextStyle(
              color: _getBalanceColor(),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
