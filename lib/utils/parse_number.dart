double? parseNumber(String text) {
  // o ? significa nullable, ou seja, retorna double ou null. tem a função de retornar null caso nao seja capaz de ler 
  final normalizedText = text.trim().replaceAll(',', '.');
/* 
destrinchando: criei a final normalizedText
dentro, o .trim() remove espaços em branco da string
replaceAll(',', '.') troca a , por . 
*/
  return double.tryParse(normalizedText); // retorna a string formatada em . e em double
}