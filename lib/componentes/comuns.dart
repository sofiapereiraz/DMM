import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';

String formatarReais(double valor) {
  return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
}

String formatarDataCurta(DateTime data) {
  const meses = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return '${data.day} de ${meses[data.month - 1]}';
}

Widget avatarMascote({double tamanho = 40}) {
  return Container(
    width: tamanho,
    height: tamanho,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: AssetImage('assets/images/mascote_transparente.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget logoMedMind({double largura = 190}) {
  return Image.asset(
    'assets/images/logo_horizontal_transparente.png',
    width: largura,
    fit: BoxFit.contain,
  );
}

Widget secaoTitulo({
  required String titulo,
  String? acao,
  VoidCallback? onAcao,
}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Cores.texto,
          ),
        ),
      ),
      if (acao != null)
        TextButton(
          onPressed: onAcao,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: const Color(0xFF6B8AFD),
          ),
          child: Text(
            acao,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
    ],
  );
}

Widget iconePeriodo(PeriodoMedicamento periodo, {double tamanho = 40}) {
  Color fundo;
  Color cor;
  IconData icone;

  if (periodo == PeriodoMedicamento.manha) {
    fundo = Cores.amarelo;
    cor = const Color(0xFFE8A300);
    icone = Icons.wb_sunny_rounded;
  } else if (periodo == PeriodoMedicamento.tarde) {
    fundo = Cores.laranja;
    cor = const Color(0xFFE86A17);
    icone = Icons.light_mode_rounded;
  } else {
    fundo = Cores.roxo;
    cor = const Color(0xFF4A4CDC);
    icone = Icons.nightlight_round;
  }

  return Container(
    width: tamanho,
    height: tamanho,
    decoration: BoxDecoration(color: fundo, shape: BoxShape.circle),
    child: Icon(icone, color: cor, size: tamanho * 0.52),
  );
}
