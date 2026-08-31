import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';

class CategoryHistoryPage extends StatelessWidget {
  final List<Expense> expenses;

  const CategoryHistoryPage({
    super.key,
    required this.expenses,
  });

  List<Expense> getExpensesByCategory(CategoryType category) {
    final categoryExpenses = <Expense>[];

    // Adiciona à nova lista apenas gastos da categoria recebida.
    for (final expense in expenses) {
      if (expense.category == category) {
        categoryExpenses.add(expense);
      }
    }

    return categoryExpenses;
  }

  double getCategoryTotal(List<Expense> categoryExpenses) {
    double total = 0;

    for (final expense in categoryExpenses) {
      total += expense.amount;
    }

    return total;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos por categoria'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: CategoryType.values.length,
        itemBuilder: (context, index) {
          final category = CategoryType.values[index];
          final categoryExpenses = getExpensesByCategory(category);
          final categoryTotal = getCategoryTotal(categoryExpenses);

          return ExpansionTile(
            title: Text(getCategoryName(category)),
            subtitle: Text(
              'Subtotal: R\$ ${categoryTotal.toStringAsFixed(2)}',
            ),
            children: categoryExpenses.isEmpty
                ? const [
                    ListTile(
                      title: Text('Nenhum gasto nesta categoria.'),
                    ),
                  ]
                : categoryExpenses.map((expense) {
                    return ListTile(
                      title: Text(expense.description),
                      trailing: Text(
                        'R\$ ${expense.amount.toStringAsFixed(2)}',
                      ),
                    );
                  }).toList(),
          );
        },
      ),
    );
  }
}