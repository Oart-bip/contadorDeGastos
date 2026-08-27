import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.description),
      subtitle: Text(expense.category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('R\$ ${expense.amount.toStringAsFixed(2)}'),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}