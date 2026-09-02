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
  final descriptionController = TextEditingController(); // le o texto digitado na descricao
  final amountController = TextEditingController(); // le o texto digitado no valor

  CategoryType selectedCategory = CategoryType.outros; // guarda a categoria escolhida
  final List<Expense> expenses = []; // guarda os gastos cadastrados

  void removeExpense(int index) { // remove um gasto e atualiza a tela
    setState(() {
      expenses.removeAt(index);
    });
  }

  double getTotalAmount() { // percorre a lista e calcula o total geral
    double total = 0;

    for (final expense in expenses) {
      total += expense.amount; // soma o valor de cada gasto
    }

    return total;
  }

  void addExpense() { // valida os campos, cria e adiciona um novo gasto
    final description = descriptionController.text.trim(); // remove espacos extras da descricao
    final amount = parseNumber(amountController.text); // converte o texto do valor para double

    if (description.isEmpty || amount == null) { // impede cadastro com dados invalidos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha uma descrição e um valor válido.'),
        ),
      );
      return;
    }

    setState(() { // atualiza a tela depois de mudar a lista
      expenses.add(
        Expense(
          description: description,
          amount: amount,
          category: selectedCategory,
        ),
      );

      descriptionController.clear(); // limpa os campos para o proximo cadastro
      amountController.clear();
      selectedCategory = CategoryType.outros;
    });
  }

  @override
  void dispose() { // libera os controllers ao sair da tela
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = getTotalAmount(); // calcula o total sempre que a tela atualiza

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Gastos por categoria',
            onPressed: () { // abre a tela de historico enviando a lista atual
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
              items: CategoryType.values.map((category) { // cria uma opcao para cada valor do enum
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (category) {
                if (category != null) {
                  setState(() { // atualiza a categoria selecionada
                    selectedCategory = category;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addExpense, // chama a funcao que cadastra o gasto
                child: const Text('Adicionar gasto'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: R\$ ${totalAmount.toStringAsFixed(2)}', // mostra o total com duas casas decimais
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(
                      child: Text('Nenhum gasto cadastrado ainda.'),
                    )
                  : ListView.builder( // cria um item visual para cada gasto da lista
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];

                        return ExpenseItem(
                          expense: expense,
                          onDelete: () => removeExpense(index), // envia a acao de exclusao ao widget
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