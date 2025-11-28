import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/transaction.dart' as model;
import '../widgets/transaction_card.dart';
import '../widgets/balance_display.dart';

/// Home screen displaying balance and transaction list
/// Requirements: 5.1, 5.2, 5.4, 9.1, 9.2, 9.3, 9.5
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    
    final userId = authProvider.currentUser?.id;
    if (userId != null) {
      await Future.wait([
        transactionProvider.loadTransactions(userId),
        categoryProvider.loadCategories(userId),
      ]);
    }
  }

  void _handleLogout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    
    // Navigate back to LoginScreen (Requirement 2.4)
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _navigateToTransactionForm({model.Transaction? transaction}) {
    // Navigate to TransactionFormScreen
    Navigator.of(context).pushNamed(
      '/transaction-form',
      arguments: transaction,
    ).then((_) => _loadData());
  }

  void _navigateToCategoryManagement() {
    // Navigate to CategoryManagementScreen
    Navigator.of(context).pushNamed('/category-management').then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.name ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $userName'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _navigateToCategoryManagement,
            tooltip: 'Gestionar Categorías',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            if (transactionProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // Balance display (Requirements 9.1, 9.2, 9.3, 9.5)
                BalanceDisplay(balance: transactionProvider.balance),
                
                // Transaction list (Requirements 5.1, 5.2, 5.4)
                Expanded(
                  child: transactionProvider.transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay transacciones',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Agrega tu primera transacción',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: transactionProvider.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionProvider.transactions[index];
                            final category = Provider.of<CategoryProvider>(context)
                                .categories
                                .firstWhere(
                                  (c) => c.id == transaction.categoryId,
                                  orElse: () => throw Exception('Category not found'),
                                );
                            
                            return TransactionCard(
                              transaction: transaction,
                              category: category,
                              onTap: () => _navigateToTransactionForm(
                                transaction: transaction,
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'income',
            onPressed: () => _navigateToTransactionForm(),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'expense',
            onPressed: () => _navigateToTransactionForm(),
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
