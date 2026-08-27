double? parseNumber(String text) {
  final normalizedText = text.trim().replaceAll(',', '.'); // O ? significa que a função pode retornar um double ou null

  /* trim() remove espaços replaceAll troca vírgula por ponto
   o RegExp procura um numero inteiro ou decimal, como 10 ou 10.50 */
  final regExp = RegExp(r'[0-9]+\.?[0-9]*'); // * significa zero ou mais números depois do ponto
  // com RegExp, definimos um padrão que a string digitada deverá ter ao ser verificada 
  final matches = regExp.allMatches(normalizedText).toList();
  if (matches.length != 1 || matches.first.group(0) != normalizedText) { // so aceita se existir um numero e ele corresponder ao texto inteiro
    return null;
  }
  return double.parse(matches.first.group(0)!); // converte o texto numerico encontrado para double

  
}