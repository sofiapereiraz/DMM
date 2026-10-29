import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';
import '../componentes/cartoes.dart';
import '../componentes/comuns.dart';
import '../componentes/formulario.dart';

class MedicamentoScreen extends StatefulWidget {
  const MedicamentoScreen({
    super.key,
    required this.medicamento,
    required this.aoAlternar,
  });

  final Medicamento medicamento;
  final VoidCallback aoAlternar;

  @override
  State<MedicamentoScreen> createState() => _MedicamentoScreenState();
}

class _MedicamentoScreenState extends State<MedicamentoScreen> {
  late bool _concluido;

  void initState() {
    super.initState();
    _concluido = widget.medicamento.concluido;
  }

  void _alternar() {
    setState(() => _concluido = !_concluido);
    widget.aoAlternar();
  }

  @override
  Widget build(BuildContext context) {
    final medicamento = widget.medicamento;

    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        backgroundColor: Cores.primariaEscura,
        foregroundColor: Colors.white,
        title: const Text(
          'Detalhes do medicamento',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        children: [
          Center(child: iconePeriodo(medicamento.periodo, tamanho: 84)),
          const SizedBox(height: 16),
          Text(
            medicamento.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _concluido
                    ? const Color(0xFFE4F8EC)
                    : const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _concluido ? 'Tomado hoje' : 'Pendente hoje',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: _concluido
                      ? const Color(0xFF1B9C55)
                      : const Color(0xFF856404),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Cores.borda),
            ),
            child: Column(
              children: [
                linhaInfo(
                  rotulo: 'Horário',
                  valor: medicamento.horario,
                  icone: Icons.schedule_rounded,
                ),
                separadorInfo(),
                linhaInfo(
                  rotulo: 'Dosagem',
                  valor: medicamento.dosagem,
                  icone: Icons.medication_rounded,
                ),
                separadorInfo(),
                linhaInfo(
                  rotulo: 'Período',
                  valor: medicamento.periodo.rotulo,
                  icone: Icons.wb_twilight_rounded,
                ),
                if (medicamento.estoqueDias != null) ...[
                  separadorInfo(),
                  linhaInfo(
                    rotulo: 'Estoque estimado',
                    valor: '${medicamento.estoqueDias} dias restantes',
                    icone: Icons.inventory_2_rounded,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          cartaoDica(
            icone: Icons.info_outline_rounded,
            titulo: 'Informação importante',
            subtitulo:
                'Este é um protótipo educativo. Não substitua a orientação '
                'de um médico ou farmacêutico.',
          ),
          const SizedBox(height: 22),
          botaoApp(
            texto: _concluido
                ? 'Desmarcar como tomado'
                : 'Marcar como tomado',
            icone: _concluido ? Icons.undo_rounded : Icons.check_rounded,
            onPressed: _alternar,
          ),
          const SizedBox(height: 10),
          botaoApp(
            texto: 'Voltar',
            estilo: EstiloBotao.contorno,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

Widget linhaInfo({
  required String rotulo,
  required String valor,
  required IconData icone,
}) {
  return Row(
    children: [
      Icon(icone, size: 19, color: Cores.azulClaro),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          rotulo,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF7A8190)),
        ),
      ),
      Text(
        valor,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Cores.texto,
        ),
      ),
    ],
  );
}

Widget separadorInfo() {
  return Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 12),
    color: Cores.borda,
  );
}
