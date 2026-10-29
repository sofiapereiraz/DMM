import 'package:flutter/material.dart';

import '../models/medicamento.dart';
import '../tema/tema.dart';
import 'comuns.dart';

ButtonStyle estiloCartao() {
  return TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    foregroundColor: Cores.texto,
    overlayColor: Colors.transparent,
  );
}

Widget cartaoDica({
  required IconData icone,
  required String titulo,
  String? subtitulo,
  Color corFundo = Cores.azulSuave,
  Color cor = const Color(0xFF197ABD),
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: corFundo,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icone, color: cor, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cor,
                  height: 1.35,
                ),
              ),
              if (subtitulo != null)
                Text(
                  subtitulo,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: cor,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget cartaoMedicamento({
  required Medicamento medicamento,
  VoidCallback? onTap,
  Widget? acao,
  bool mostrarStatus = false,
}) {
  final conteudo = Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Cores.borda),
    ),
    child: Row(
      children: [
        iconePeriodo(medicamento.periodo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    medicamento.horario,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Cores.texto,
                    ),
                  ),
                  if (mostrarStatus && medicamento.concluido) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F8EC),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Tomado',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B9C55),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${medicamento.nome} · ${medicamento.dosagem}',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF8B94A3),
                ),
              ),
            ],
          ),
        ),
        acao ??
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFC0C4D0),
            ),
      ],
    ),
  );

  if (onTap == null) return conteudo;

  return SizedBox(
    width: double.infinity,
    child: TextButton(
      onPressed: onTap,
      style: estiloCartao(),
      child: conteudo,
    ),
  );
}
