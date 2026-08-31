import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseItem({super.key, required this.expense, required this.onDelete});

  // Retorna o nome da categoria para exibição.
  String getCategoryName() {
    switch (expense.category) {
      case CategoryType.alimentacao:
        return 'Alimentação';

      case CategoryType.transporte:
        return 'Transporte';

      case CategoryType.lazer:
        return 'Lazer';

      case CategoryType.outros:
        return 'Outros';
    }
  }

  // Retorna um ícone para cada categoria.
  IconData getCategoryIcon() {
    switch (expense.category) {
      case CategoryType.alimentacao:
        return Icons.restaurant;

      case CategoryType.transporte:
        return Icons.directions_car;

      case CategoryType.lazer:
        return Icons.sports_esports;

      case CategoryType.outros:
        return Icons.category;
    }
  }

  // Retorna uma cor para cada categoria.
  Color getCategoryColor() {
    switch (expense.category) {
      case CategoryType.alimentacao:
        return Colors.orange;

      case CategoryType.transporte:
        return Colors.blue;

      case CategoryType.lazer:
        return Colors.purple;

      case CategoryType.outros:
        return Colors.grey;
    }
  }

  // Formata o valor no padrão brasileiro.
  String formatMoney() {
    return 'R\$ ${expense.amount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Ícone da categoria.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(getCategoryIcon(), color: categoryColor),
            ),

            const SizedBox(width: 12),

            // Descrição e categoria.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getCategoryName(),
                    style: TextStyle(
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Valor e botão de excluir.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoney(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Excluir gasto',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
