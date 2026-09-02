import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseItem extends StatelessWidget { // widget reutilizavel para exibir cada gasto
  final Expense expense; // recebe os dados do gasto
  final VoidCallback onDelete; // recebe a acao de excluir

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
      trailing: Row( // organiza o valor e o botao de excluir
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('R\$ ${expense.amount.toStringAsFixed(2)}'), // mostra o valor com duas casas decimais
          IconButton(
            onPressed: onDelete, // chama a funcao recebida da tela principal
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}