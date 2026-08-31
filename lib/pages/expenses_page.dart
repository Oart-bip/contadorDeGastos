import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';
import '../utils/parse_number.dart';
import '../widgets/expense_item.dart';
import 'category_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  CategoryType selectedCategory = CategoryType.outros;
  final List<Expense> expenses = [];

  // Remove um gasto da lista pelo índice.
  void removeExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  // Adiciona um novo gasto à lista.
  void addExpense() {
    final description = descriptionController.text.trim();
    final amount = parseNumber(amountController.text);

    // Só cria o gasto quando descrição e valor são válidos.
    if (description.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha uma descrição e um valor válido.'),
        ),
      );
      return;
    }

    setState(() {
      expenses.add(
        Expense(
          description: description,
          amount: amount,
          category: selectedCategory,
        ),
      );

      // Limpa os campos para o próximo cadastro.
      descriptionController.clear();
      amountController.clear();

      // Volta a categoria para "Outros".
      selectedCategory = CategoryType.outros;
    });
  }

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

  // Retorna o ícone correspondente à categoria.
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

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Soma todos os gastos cadastrados.
    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus gastos',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            // Campo de descrição.
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex.: Mercado',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Campo de valor.
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Valor',
                hintText: 'Ex.: 25,90',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Seleção da categoria.
            DropdownButtonFormField<CategoryType>(
              initialValue: selectedCategory,
              key: ValueKey(selectedCategory),
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),

              items: CategoryType.values.map((category) {
                return DropdownMenuItem<CategoryType>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(getCategoryIcon(category), size: 20),
                      const SizedBox(width: 8),
                      Text(getCategoryName(category)),
                    ],
                  ),
                );
              }).toList(),

              selectedItemBuilder: (context) {
                return CategoryType.values.map((category) {
                  return Row(
                    children: [
                      Icon(getCategoryIcon(category), size: 22),
                      const SizedBox(width: 8),
                      Text(getCategoryName(category)),
                    ],
                  );
                }).toList();
              },

              onChanged: (category) {
                if (category != null) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              },
            ),

            const SizedBox(height: 14),

            // Botão para adicionar o gasto.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: addExpense,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Adicionar gasto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Card do total.
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    // Ícone do total.
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 28,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Texto "Total de gastos".
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total de gastos',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botão para abrir a tela de categorias.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(expenses: expenses),
                    ),
                  );
                },
                icon: const Icon(Icons.pie_chart_outline),
                label: const Text(
                  'Ver gastos por categoria',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Lista de gastos.
            Expanded(
              child: expenses.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 60),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum gasto cadastrado ainda.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Adicione seu primeiro gasto acima.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];

                        return ExpenseItem(
                          expense: expense,
                          onDelete: () => removeExpense(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
