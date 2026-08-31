import 'package:flutter/material.dart'; // importa os widgets do flutter
import '../enums/category_type.dart'; // importa as categorias do app
import '../models/expense.dart'; // importa o modelo de gasto
import '../utils/parse_number.dart'; // importa a conversao de texto para numero
import '../widgets/expense_item.dart'; // importa o widget reutilizavel de gasto
import 'category_history_page.dart'; // importa a tela de historico

class ExpensesPage extends StatefulWidget { // cria a tela principal do app
  const ExpensesPage({super.key}); // cria o construtor da tela

  @override // sobrescreve a criacao do estado da tela
  State<ExpensesPage> createState() => _ExpensesPageState(); // liga a tela ao estado
}

class _ExpensesPageState extends State<ExpensesPage> { // guarda dados que mudam na tela
  final descriptionController = TextEditingController(); // controla o texto da descricao
  final amountController = TextEditingController(); // controla o texto do valor

  CategoryType selectedCategory = CategoryType.outros; // guarda a categoria selecionada
  final List<Expense> expenses = []; // guarda todos os gastos cadastrados

  void removeExpense(int index) { // remove um gasto pela posicao na lista
    setState(() { // atualiza a tela depois da alteracao
      expenses.removeAt(index); // remove o gasto da lista
    });
  }

  double getTotalAmount() { // calcula o total de todos os gastos
    double total = 0; // inicia o total em zero

    for (final expense in expenses) { // percorre cada gasto cadastrado
      total += expense.amount; // soma o valor do gasto ao total
    }

    return total; // devolve o total calculado
  }

  void addExpense() { // valida e adiciona um novo gasto
    final description = descriptionController.text.trim(); // pega a descricao sem espacos extras
    final amount = parseNumber(amountController.text); // converte o texto do valor para double

    if (description.isEmpty || amount == null) { // verifica se descricao ou valor sao invalidos
      ScaffoldMessenger.of(context).showSnackBar( // mostra um aviso na tela
        const SnackBar(
          content: Text('Preencha uma descrição e um valor válido.'), // informa o erro ao usuario
        ),
      );
      return; // encerra a funcao sem cadastrar o gasto
    }

    setState(() { // atualiza a tela depois de cadastrar
      expenses.add( // adiciona um novo objeto na lista
        Expense(
          description: description, // envia a descricao para o gasto
          amount: amount, // envia o valor numerico para o gasto
          category: selectedCategory, // envia a categoria selecionada
        ),
      );

      descriptionController.clear(); // limpa o campo de descricao
      amountController.clear(); // limpa o campo de valor
      selectedCategory = CategoryType.outros; // volta a categoria inicial
    });
  }

  @override // sobrescreve o descarte da tela
  void dispose() { // libera recursos antes de fechar a pagina
    descriptionController.dispose(); // libera o controller da descricao
    amountController.dispose(); // libera o controller do valor
    super.dispose(); // executa o descarte da classe pai
  }

  @override // sobrescreve a montagem da tela
  Widget build(BuildContext context) { // constroi a interface principal
    final totalAmount = getTotalAmount(); // calcula o total antes de mostrar na tela

    return Scaffold( // cria a estrutura principal da pagina
      appBar: AppBar( // cria a barra superior
        title: const Text('Meus gastos'), // mostra o titulo da tela
        actions: [ // guarda os botoes da barra superior
          IconButton(
            icon: const Icon(Icons.list_alt), // mostra o icone de historico
            tooltip: 'Gastos por categoria', // mostra texto ao segurar o icone
            onPressed: () { // executa ao tocar no icone
              Navigator.push( // abre uma nova tela
                context, // usa o contexto atual da pagina
                MaterialPageRoute(
                  builder: (context) { // constroi a pagina de destino
                    return CategoryHistoryPage(expenses: expenses); // envia a lista para o historico
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding( // adiciona espaco nas bordas da tela
        padding: const EdgeInsets.all(16), // define o espaco de 16 pixels
        child: Column( // organiza os widgets na vertical
          children: [
            TextField(
              controller: descriptionController, // liga o campo ao controller da descricao
              decoration: const InputDecoration(
                labelText: 'Descrição', // mostra o nome do campo
                border: OutlineInputBorder(), // desenha a borda do campo
              ),
            ),
            const SizedBox(height: 12), // cria espaco entre os campos
            TextField(
              controller: amountController, // liga o campo ao controller do valor
              keyboardType: TextInputType.number, // abre o teclado numerico
              decoration: const InputDecoration(
                labelText: 'Valor', // mostra o nome do campo
                hintText: 'Ex.: 25,90', // mostra um exemplo de preenchimento
                border: OutlineInputBorder(), // desenha a borda do campo
              ),
            ),
            const SizedBox(height: 12), // cria espaco antes da categoria
            DropdownButtonFormField<CategoryType>( // cria o seletor de categoria
              value: selectedCategory, // mostra a categoria selecionada
              decoration: const InputDecoration(
                labelText: 'Categoria', // mostra o nome do seletor
                border: OutlineInputBorder(), // desenha a borda do seletor
              ),
              items: CategoryType.values.map((category) { // transforma cada enum em uma opcao
                return DropdownMenuItem(
                  value: category, // define o valor da opcao
                  child: Text(category.name), // mostra o nome da categoria
                );
              }).toList(), // transforma as opcoes em lista
              onChanged: (category) { // executa ao selecionar uma categoria
                if (category != null) { // verifica se existe categoria escolhida
                  setState(() { // atualiza a tela com a nova categoria
                    selectedCategory = category; // salva a categoria selecionada
                  });
                }
              },
            ),
            const SizedBox(height: 12), // cria espaco antes do botao
            SizedBox(
              width: double.infinity, // faz o botao ocupar toda a largura
              child: ElevatedButton(
                onPressed: addExpense, // chama a funcao de cadastro
                child: const Text('Adicionar gasto'), // mostra o texto do botao
              ),
            ),
            const SizedBox(height: 16), // cria espaco antes do total
            Text(
              'Total: R\$ ${totalAmount.toStringAsFixed(2)}', // mostra o total com duas casas decimais
              style: Theme.of(context).textTheme.titleLarge, // aplica um estilo maior ao texto
            ),
            const SizedBox(height: 16), // cria espaco antes da lista
            Expanded( // ocupa o espaco restante da tela
              child: expenses.isEmpty // verifica se existem gastos cadastrados
                  ? const Center(
                      child: Text('Nenhum gasto cadastrado ainda.'), // mostra aviso se a lista estiver vazia
                    )
                  : ListView.builder(
                      itemCount: expenses.length, // define quantos gastos serao exibidos
                      itemBuilder: (context, index) { // monta cada item da lista
                        final expense = expenses[index]; // pega o gasto da posicao atual

                        return ExpenseItem(
                          expense: expense, // envia o gasto para o widget reutilizavel
                          onDelete: () => removeExpense(index), // remove o gasto ao tocar na lixeira
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