import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';

class CategoryPage extends StatelessWidget {
  final List<Expense> expenses;

  const CategoryPage({super.key, required this.expenses});

  // Retorna o nome da categoria para exibição.
  String getCategoryName(CategoryType category) {
    switch (category) {
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

  // Retorna um ícone diferente para cada categoria.
  IconData getCategoryIcon(CategoryType category) {
    switch (category) {
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

  // Retorna uma cor diferente para cada categoria.
  Color getCategoryColor(CategoryType category) {
    switch (category) {
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

  // Filtra os gastos de uma determinada categoria.
  List<Expense> getExpensesByCategory(CategoryType category) {
    return expenses.where((expense) => expense.category == category).toList();
  }

  // Calcula o subtotal de uma categoria.
  double getCategoryTotal(List<Expense> categoryExpenses) {
    return categoryExpenses.fold<double>(
      0,
      (total, expense) => total + expense.amount,
    );
  }

  // Formata o valor no padrão brasileiro.
  String formatMoney(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o total geral.
    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gastos por categoria',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart_outline, size: 60),
                  SizedBox(height: 12),
                  Text(
                    'Nenhum gasto cadastrado ainda.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...CategoryType.values.map((category) {
                  final categoryExpenses = getExpensesByCategory(category);

                  // Não mostra categorias sem gastos.
                  if (categoryExpenses.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final subtotal = getCategoryTotal(categoryExpenses);

                  final categoryColor = getCategoryColor(category);

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho da categoria.
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  getCategoryIcon(category),
                                  color: categoryColor,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Text(
                                getCategoryName(category),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Gastos da categoria.
                          ...categoryExpenses.map((expense) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      expense.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatMoney(expense.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const Divider(height: 20),

                          // Subtotal.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formatMoney(subtotal),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 4),

                // Total geral.
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Text(
                            'Total geral',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          formatMoney(total),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
