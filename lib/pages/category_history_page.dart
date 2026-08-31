import 'package:flutter/material.dart'; // importa os widgets do flutter
import '../enums/category_type.dart'; // importa as categorias do app
import '../models/expense.dart'; // importa o modelo de gasto

class CategoryHistoryPage extends StatelessWidget { // cria a tela de gastos por categoria
  final List<Expense> expenses; // recebe a lista de gastos cadastrados

  const CategoryHistoryPage({
    super.key, // envia a chave para o widget pai
    required this.expenses, // exige a lista de gastos ao abrir a tela
  });

  List<Expense> getExpensesByCategory(CategoryType category) { // filtra gastos de uma categoria
    final categoryExpenses = <Expense>[]; // cria uma lista vazia para a categoria

    for (final expense in expenses) { // percorre todos os gastos cadastrados
      if (expense.category == category) { // verifica se o gasto pertence a categoria
        categoryExpenses.add(expense); // adiciona o gasto na lista da categoria
      }
    }

    return categoryExpenses; // devolve os gastos filtrados
  }

  double getCategoryTotal(List<Expense> categoryExpenses) { // calcula o subtotal da categoria
    double total = 0; // inicia o total em zero

    for (final expense in categoryExpenses) { // percorre os gastos da categoria
      total += expense.amount; // soma o valor do gasto ao subtotal
    }

    return total; // devolve o subtotal calculado
  }

  String getCategoryName(CategoryType category) { // transforma o enum em texto para a tela
    switch (category) { // verifica qual categoria foi recebida
      case CategoryType.alimentacao:
        return 'Alimentação'; // devolve o nome da alimentacao
      case CategoryType.transporte:
        return 'Transporte'; // devolve o nome do transporte
      case CategoryType.lazer:
        return 'Lazer'; // devolve o nome do lazer
      case CategoryType.outros:
        return 'Outros'; // devolve o nome de outros
    }
  }

  @override // sobrescreve o metodo de montagem da tela
  Widget build(BuildContext context) { // constroi a interface da pagina
    return Scaffold( // cria a estrutura principal da tela
      appBar: AppBar( // cria a barra superior
        title: const Text('Gastos por categoria'), // mostra o titulo da pagina
      ),
      body: ListView.builder( // cria uma lista com as categorias
        padding: const EdgeInsets.all(16), // adiciona espaco nas bordas
        itemCount: CategoryType.values.length, // define a quantidade de categorias
        itemBuilder: (context, index) { // monta cada categoria da lista
          final category = CategoryType.values[index]; // pega a categoria da vez
          final categoryExpenses = getExpensesByCategory(category); // filtra seus gastos
          final categoryTotal = getCategoryTotal(categoryExpenses); // calcula seu subtotal

          return ExpansionTile( // cria um item que pode abrir e fechar
            title: Text(getCategoryName(category)), // mostra o nome da categoria
            subtitle: Text( // mostra uma informacao abaixo do titulo
              'Subtotal: R\$ ${categoryTotal.toStringAsFixed(2)}', // formata o subtotal
            ),
            children: categoryExpenses.isEmpty // verifica se a categoria esta vazia
                ? const [
                    ListTile(
                      title: Text('Nenhum gasto nesta categoria.'), // avisa que nao ha gastos
                    ),
                  ]
                : categoryExpenses.map((expense) { // transforma cada gasto em um item visual
                    return ListTile( // cria a linha de um gasto
                      title: Text(expense.description), // mostra a descricao do gasto
                      trailing: Text( // posiciona o valor no fim da linha
                        'R\$ ${expense.amount.toStringAsFixed(2)}', // formata o valor
                      ),
                    );
                  }).toList(), // transforma os itens em lista para o expansiontile
          );
        },
      ),
    );
  }
}