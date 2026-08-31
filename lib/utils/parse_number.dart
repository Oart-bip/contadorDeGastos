double? parseNumber(String text) {
  // Remove espaços e troca vírgula por ponto.
  final normalizedText = text.trim().replaceAll(',', '.');

  // Aceita números inteiros ou decimais.
  final regExp = RegExp(r'^[0-9]+(?:\.[0-9]+)?$');

  // Verifica se o texto inteiro corresponde ao padrão.
  if (!regExp.hasMatch(normalizedText)) {
    return null;
  }

  // Converte o texto para double.
  return double.parse(normalizedText);
}
