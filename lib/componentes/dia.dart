import 'package:flutter/material.dart';

import '../tema/tema.dart';

Widget diaCalendario({
  required DateTime data,
  required bool selecionado,
  required VoidCallback onTap,
}) {
  const rotulos = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  return Expanded(
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      child: Column(
        children: [
          Text(
            rotulos[data.weekday - 1],
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Color(0xFF47729C),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 27,
            height: 27,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selecionado ? Cores.texto : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${data.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selecionado ? Colors.white : Cores.texto,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
