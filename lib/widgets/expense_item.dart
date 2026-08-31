import 'package:flutter/material.dart'; // importa os widgets do flutter

import '../models/expense.dart'; // importa o modelo de gasto

class ExpenseItem extends StatelessWidget { // cria um widget reutilizavel para cada gasto
  final Expense expense; // recebe os dados de um gasto
  final VoidCallback onDelete; // recebe a funcao para excluir o gasto

  const ExpenseItem({
    super.key, // envia a chave para o widget pai
    required this.expense, // exige um gasto para exibir
    required this.onDelete, // exige uma funcao para excluir
  });

  @override // sobrescreve a montagem do widget
  Widget build(BuildContext context) { // constroi a linha de gasto
    return ListTile( // cria uma linha organizada na lista
      title: Text(expense.description), // mostra a descricao do gasto
      subtitle: Text(expense.category.name), // mostra a categoria do gasto
      trailing: Row( // organiza valor e lixeira na horizontal
        mainAxisSize: MainAxisSize.min, // ocupa somente o espaco necessario
        children: [
          Text('R\$ ${expense.amount.toStringAsFixed(2)}'), // mostra o valor com duas casas decimais
          IconButton(
            onPressed: onDelete, // chama a funcao que exclui o gasto
            icon: const Icon(Icons.delete_outline), // mostra o icone de lixeira
          ),
        ],
      ),
    );
  }
}