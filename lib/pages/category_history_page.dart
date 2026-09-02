import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';

class CategoryHistoryPage extends StatelessWidget {
  final List<Expense> expenses; // recebe a lista cadastrada na tela principal

  const CategoryHistoryPage({
    super.key,
    required this.expenses,
  });

  List<Expense> getExpensesByCategory(CategoryType category) { // filtra somente gastos da categoria recebida
    final categoryExpenses = <Expense>[];

    for (final expense in expenses) {
      if (expense.category == category) {
        categoryExpenses.add(expense);
      }
    }

    return categoryExpenses;
  }

  double getCategoryTotal(List<Expense> categoryExpenses) { // soma os valores de uma categoria
    double total = 0;

    for (final expense in categoryExpenses) {
      total += expense.amount;
    }

    return total;
  }

  String getCategoryName(CategoryType category) { // transforma o enum em um nome para exibir
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
      body: ListView.builder( // cria uma secao para cada categoria do enum
        padding: const EdgeInsets.all(16),
        itemCount: CategoryType.values.length,
        itemBuilder: (context, index) {
          final category = CategoryType.values[index];
          final categoryExpenses = getExpensesByCategory(category); // busca os gastos da categoria atual
          final categoryTotal = getCategoryTotal(categoryExpenses); // calcula seu subtotal

          return ExpansionTile( // permite abrir e fechar a lista de gastos
            title: Text(getCategoryName(category)),
            subtitle: Text(
              'Subtotal: R\$ ${categoryTotal.toStringAsFixed(2)}', // mostra o subtotal com duas casas decimais
            ),
            children: categoryExpenses.isEmpty
                ? const [
                    ListTile(
                      title: Text('Nenhum gasto nesta categoria.'),
                    ),
                  ]
                : categoryExpenses.map((expense) { // transforma cada gasto em uma linha visual
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