import 'package:flutter/material.dart';

class Cores {
  static const Color primaria = Color(0xFF3F49DA);
  static const Color primariaEscura = Color(0xFF17186C);
  static const Color azulProfundo = Color(0xFF10115F);
  static const Color azul = Color(0xFF292CA0);
  static const Color azulClaro = Color(0xFF4AA9ED);
  static const Color azulSuave = Color(0xFFDCEFFF);
  static const Color fundo = Color(0xFFF5F6FA);
  static const Color branco = Colors.white;
  static const Color texto = Color(0xFF151515);
  static const Color textoSecundario = Color(0xFF9CA3AF);
  static const Color borda = Color(0xFFEDF1F5);
  static const Color verde = Color(0xFF00C853);
  static const Color amarelo = Color(0xFFFFF0AE);
  static const Color laranja = Color(0xFFFFE0C1);
  static const Color roxo = Color(0xFFE2E1FF);
}

class TemaApp {
  static ThemeData get claro {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Cores.primaria,
        primary: Cores.primaria,
        surface: Cores.branco,
      ),
      scaffoldBackgroundColor: Cores.fundo,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: Cores.texto,
        displayColor: Cores.texto,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Cores.primariaEscura,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
