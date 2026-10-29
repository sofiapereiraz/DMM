import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'tema/tema.dart';
import 'telas/entrada.dart';

class MedMindApp extends StatelessWidget {
  const MedMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedMind',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
