# Contador de Gastos

Aplicativo desenvolvido em Flutter para registrar e acompanhar gastos do dia a dia.

## Funcionalidades

- Cadastro de gastos com descrição, valor e categoria.
- Categorias: Alimentação, Transporte, Lazer e Outros.
- Exibição de todos os gastos cadastrados.
- Exclusão de gastos.
- Cálculo automático do total geral.
- Tela de gastos separados por categoria.
- Cálculo de subtotal por categoria.
- Cores e ícones diferentes para cada categoria.
- Navegação entre telas utilizando `Navigator.push`.
- Validação dos dados informados pelo usuário.
- Suporte à vírgula como separador decimal, por exemplo `25,90`.

## Conceitos utilizados

- `StatefulWidget`
- `setState()`
- `List`
- `enum`
- Widgets customizados
- `Navigator.push`
- `MaterialPageRoute`
- `RegExp`
- Conversão de `String` para `double`

## Estrutura principal

```text
lib/
├── enums/
│   └── category_type.dart
├── models/
│   └── expense.dart
├── pages/
│   ├── expenses_page.dart
│   └── category_page.dart
├── utils/
│   └── parse_number.dart
└── widgets/
    └── expense_item.dart