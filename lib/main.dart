import 'package:flutter/material.dart';

import 'pages/expenses_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Tema principal do aplicativo.
      theme: ThemeData(
        useMaterial3: true,

        // Define a cor principal do aplicativo.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4DB8)),

        // Cor de fundo das telas.
        scaffoldBackgroundColor: const Color(0xFFFFF8FF),

        // Estilo padrão da AppBar.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8FF),
          foregroundColor: Color(0xFF25222A),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),

        // Estilo padrão dos botões elevados.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEDE3F5),
            foregroundColor: const Color(0xFF6B4DB8),
            elevation: 1,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        // Estilo padrão dos botões com borda.
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF6B4DB8),
            side: const BorderSide(color: Color(0xFF8B78A8)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        // Estilo padrão dos Cards.
        cardTheme: CardThemeData(
          color: const Color(0xFFFFF8FF),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Estilo padrão dos campos de texto.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFF8FF),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF6B4DB8), width: 2),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),

      home: const ExpensesPage(),
    );
  }
}
