import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/transaction.dart' as model;
import '../models/transaction_type.dart';
import '../utils/user_feedback.dart';
import '../utils/formatters.dart';

/// Screen for creating and editing transactions
/// Requirements: 3.1, 3.2, 3.3, 4.1, 4.2, 4.3, 6.1, 6.4
class TransactionFormScreen extends StatefulWidget {
  final model.Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late TransactionType _selectedType;
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isEditMode = false;
  model.Transaction? _transaction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get transaction from route arguments if not passed via constructor
    if (widget.transaction == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is model.Transaction) {
        _transaction = args;
      }
    } else {
      _transaction = widget.transaction;
    }
    
    // Initialize form only once
    if (!_isEditMode && _transaction != null) {
      _isEditMode = true;
      _selectedType = _transaction!.type;
      _amountController.text = _transaction!.amount.toString();
      _descriptionController.text = _transaction!.description;
      _selectedCategoryId = _transaction!.categoryId;
      _selectedDate = _transaction!.date;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedType = TransactionType.income;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategoryId == null) {
        UserFeedback.showError('Por favor selecciona una categoría');
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      final userId = authProvider.currentUser?.id;

      if (userId == null) return;

      final transaction = model.Transaction(
        id: _isEditMode ? _transaction!.id : null,
        userId: userId,
        type: _selectedType,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        createdAt: _isEditMode ? _transaction!.createdAt : DateTime.now(),
      );

      bool success;
      if (_isEditMode) {
        success = await transactionProvider.updateTransaction(transaction);
      } else {
        success = await transactionProvider.addTransaction(transaction);
      }

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
        UserFeedback.showSuccess(
          _isEditMode
              ? 'Transacción actualizada exitosamente'
              : 'Transacción creada exitosamente',
        );
      } else {
        final errorMessage = transactionProvider.errorMessage ?? 'Error al guardar la transacción';
        UserFeedback.showErrorDialog(
          context,
          'Error',
          errorMessage,
        );
      }
    }
  }

  void _handleCancel() {
    // Cancel functionality - preserves original data (Requirement 6.4)
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Transacción' : 'Nueva Transacción'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _handleCancel,
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type selector (Requirements 3.1, 4.1)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward, size: 18),
                              SizedBox(width: 8),
                              Text('Ingreso'),
                            ],
                          ),
                          selected: _selectedType == TransactionType.income,
                          selectedColor: Colors.green.withValues(alpha: 0.3),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = TransactionType.income;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward, size: 18),
                              SizedBox(width: 8),
                              Text('Gasto'),
                            ],
                          ),
                          selected: _selectedType == TransactionType.expense,
                          selectedColor: Colors.red.withValues(alpha: 0.3),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = TransactionType.expense;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Amount field (Requirements 3.3, 4.3)
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El monto es requerido';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Ingresa un monto válido';
                  }
                  if (amount <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              // Category dropdown
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categoryProvider.categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Date picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    Formatters.formatDate(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Save button
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditMode ? 'Actualizar' : 'Guardar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
