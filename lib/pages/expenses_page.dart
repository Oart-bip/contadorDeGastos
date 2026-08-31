import 'package:flutter/material.dart';

import '../enums/category_type.dart';
import '../models/expense.dart';
import '../utils/parse_number.dart';
import '../widgets/expense_item.dart';
import 'category_history_page.dart';

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

  void removeExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  double getTotalAmount() {
    double total = 0;

    // Percorre todos os gastos e acumula seus valores.
    for (final expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

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
      selectedCategory = CategoryType.outros;
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = getTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Gastos por categoria',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryHistoryPage(expenses: expenses);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor',
                hintText: 'Ex.: 25,90',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CategoryType>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: CategoryType.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (category) {
                if (category != null) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addExpense,
                child: const Text('Adicionar gasto'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: R\$ ${totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text('Nenhum gasto cadastrado ainda.'))
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
