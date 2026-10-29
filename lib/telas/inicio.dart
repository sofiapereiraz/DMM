import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';
import '../models/usuario.dart';
import '../componentes/cartoes.dart';
import '../componentes/comuns.dart';

class Inicio extends StatelessWidget {
  const Inicio({
    super.key,
    required this.usuario,
    required this.medicamentos,
    required this.pendentes,
    required this.onAbrirLembretes,
    required this.onAbrirMedicamento,
  });

  final Usuario usuario;
  final List<Medicamento> medicamentos;
  final int pendentes;
  final VoidCallback onAbrirLembretes;
  final ValueChanged<Medicamento> onAbrirMedicamento;

  @override
  Widget build(BuildContext context) {
    final ordenados = [...medicamentos]
      ..sort((a, b) => a.horario.compareTo(b.horario));

    return Column(
      children: [
        cabecalhoInicio(
          usuario: usuario,
          pendentes: pendentes,
          onAbrirLembretes: onAbrirLembretes,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              secaoTitulo(
                titulo: 'Próximos horários',
                acao: 'Ver mais',
                onAcao: onAbrirLembretes,
              ),
              const SizedBox(height: 10),
              if (ordenados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(
                      'Nenhum medicamento cadastrado ainda.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Cores.textoSecundario,
                      ),
                    ),
                  ),
                )
              else
                for (final medicamento in ordenados)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: cartaoMedicamento(
                      medicamento: medicamento,
                      mostrarStatus: true,
                      onTap: () => onAbrirMedicamento(medicamento),
                    ),
                  ),
              const SizedBox(height: 4),
              cartaoDica(
                icone: Icons.shield_rounded,
                titulo: 'Mantenha sua rotina em dia',
                subtitulo: 'e cuide do seu bem-estar!',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget cabecalhoInicio({
  required Usuario usuario,
  required int pendentes,
  required VoidCallback onAbrirLembretes,
}) {
  String textoMascote;
  if (pendentes == 0) {
    textoMascote = 'Tudo em dia! Você já tomou todos hoje.';
  } else if (pendentes == 1) {
    textoMascote = 'Você tem 1 medicamento hoje';
  } else {
    textoMascote = 'Você tem $pendentes medicamentos hoje';
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(22, 34, 22, 18),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Cores.azulProfundo, Cores.azul],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo_transparente.png',
              width: 46,
              height: 46,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 9),
            const Row(
              children: [
                Text(
                  'Med',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8FB9E8),
                  ),
                ),
                Text(
                  'Mind',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3AE0CE),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Olá, ${usuario.primeiroNome}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Sua saúde em boas mãos.',
          style: TextStyle(fontSize: 12, color: Color(0xFFCDD2FF)),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onAbrirLembretes,
            style: estiloCartao(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/mascote_transparente.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      textoMascote,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: Cores.texto,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Cores.primaria,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
