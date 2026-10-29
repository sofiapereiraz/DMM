import 'package:flutter/material.dart';

import '../tema/tema.dart';

class ItemBarra {
  const ItemBarra({required this.icone, required this.rotulo});

  final IconData icone;
  final String rotulo;
}

Widget barraNavegacao({
  required int indiceAtual,
  required ValueChanged<int> onSelecionar,
}) {
  const itens = [
    ItemBarra(icone: Icons.home_rounded, rotulo: 'Home'),
    ItemBarra(icone: Icons.camera_alt_rounded, rotulo: 'Câmera'),
    ItemBarra(icone: Icons.notifications_rounded, rotulo: 'Lembretes'),
  ];

  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      boxShadow: [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 12,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      children: [
        for (var indice = 0; indice < itens.length; indice++)
          Expanded(
            child: itemBarra(
              item: itens[indice],
              selecionado: indice == indiceAtual,
              onTap: () => onSelecionar(indice),
            ),
          ),
      ],
    ),
  );
}

Widget itemBarra({
  required ItemBarra item,
  required bool selecionado,
  required VoidCallback onTap,
}) {
  final cor = selecionado ? Cores.primaria : Cores.textoSecundario;

  return TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 4),
      minimumSize: const Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: Colors.transparent,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icone, size: 21, color: cor),
        const SizedBox(height: 4),
        Text(
          item.rotulo,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
            color: cor,
          ),
        ),
      ],
    ),
  );
}
