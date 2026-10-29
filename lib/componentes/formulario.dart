import 'package:flutter/material.dart';

import '../tema/tema.dart';

enum EstiloBotao { primario, escuro, claro, contorno }

Widget botaoApp({
  required String texto,
  required VoidCallback? onPressed,
  EstiloBotao estilo = EstiloBotao.primario,
  bool carregando = false,
  IconData? icone,
  double raio = 12,
}) {
  final habilitado = onPressed != null && !carregando;

  Color fundo;
  Color corTexto;
  Color corBorda;

  if (estilo == EstiloBotao.primario) {
    fundo = Cores.primaria;
    corTexto = Colors.white;
    corBorda = Colors.transparent;
  } else if (estilo == EstiloBotao.escuro) {
    fundo = const Color(0xFF050B22);
    corTexto = Colors.white;
    corBorda = const Color(0xFF2C2C2C);
  } else if (estilo == EstiloBotao.claro) {
    fundo = Colors.white;
    corTexto = Cores.texto;
    corBorda = const Color(0xFFD9D9D9);
  } else {
    fundo = Colors.transparent;
    corTexto = Cores.primaria;
    corBorda = Cores.primaria;
  }

  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: habilitado ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: fundo,
        foregroundColor: corTexto,
        disabledBackgroundColor: fundo.withValues(alpha: 0.5),
        disabledForegroundColor: corTexto.withValues(alpha: 0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(raio),
          side: BorderSide(color: corBorda),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      child: carregando
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icone != null) ...[
                  Icon(icone, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(texto, overflow: TextOverflow.ellipsis),
              ],
            ),
    ),
  );
}

Widget campoTexto({
  required String rotulo,
  required TextEditingController controlador,
  String? dica,
  bool senha = false,
  TextInputType? teclado,
  Widget? sufixo,
  String? erro,
  ValueChanged<String>? aoMudar,
  ValueChanged<String>? aoEnviar,
  bool somenteLeitura = false,
  TextCapitalization capitalizacao = TextCapitalization.none,
  int linhas = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        rotulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Cores.texto,
        ),
      ),
      const SizedBox(height: 7),
      TextField(
        controller: controlador,
        obscureText: senha,
        keyboardType: teclado,
        onChanged: aoMudar,
        onSubmitted: aoEnviar,
        readOnly: somenteLeitura,
        textCapitalization: capitalizacao,
        maxLines: linhas,
        style: TextStyle(
          fontSize: 15,
          color: somenteLeitura ? const Color(0xFF5A6472) : Cores.texto,
        ),
        decoration: InputDecoration(
          hintText: dica,
          hintStyle: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 14),
          filled: true,
          fillColor: somenteLeitura ? const Color(0xFFF1F4F8) : Colors.white,
          suffixIcon: sufixo,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 46,
            minHeight: 46,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: bordaCampo(const Color(0xFFD9D9D9)),
          enabledBorder: bordaCampo(
            erro == null ? const Color(0xFFD9D9D9) : const Color(0xFFE53935),
          ),
          focusedBorder: bordaCampo(
            erro == null ? Cores.azulClaro : const Color(0xFFE53935),
            largura: 1.6,
          ),
        ),
      ),
      if (erro != null) ...[
        const SizedBox(height: 4),
        Text(
          erro,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFFE53935)),
        ),
      ],
    ],
  );
}

OutlineInputBorder bordaCampo(Color cor, {double largura = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: cor, width: largura),
  );
}

Widget campoBusca({
  required TextEditingController controlador,
  required String dica,
  ValueChanged<String>? aoMudar,
}) {
  return TextField(
    controller: controlador,
    onChanged: aoMudar,
    style: const TextStyle(fontSize: 13.5),
    decoration: InputDecoration(
      hintText: dica,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9AA3B2)),
      prefixIcon: const Icon(
        Icons.search_rounded,
        size: 20,
        color: Color(0xFF9AA3B2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE4E9F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE4E9F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Cores.azulClaro, width: 1.4),
      ),
    ),
  );
}
