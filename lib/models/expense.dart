import '../enums/category_type.dart';
// modelo expense que guardara cada gasto

// final para que meus dados não sejam alterados diretamente. Correção apenas com a exclusao do cadastro e começando dnv

class Expense {
  final String description;
  final double amount;
  final CategoryType category;

  Expense({ // criacao do construtor 
    required this.description,
    required this.amount,
    required this.category,
  });
}