import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';
import '../componentes/cartoes.dart';
import '../componentes/formulario.dart';
import '../services/medicamento_service.dart';

class Camera extends StatefulWidget {
  const Camera({
    super.key,
    required this.medicamentos,
    required this.aoAdicionar,
  });

  final List<Medicamento> medicamentos;
  final bool Function(Medicamento) aoAdicionar;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final _service = const MedicamentoService();

  bool _lendo = true;
  List<Medicamento> _detectados = [];

  @override
  void initState() {
    super.initState();
    _lerReceita();
  }

  Future<void> _lerReceita() async {
    setState(() {
      _lendo = true;
      _detectados = [];
    });

    final lista = await _service.lerReceita();
    if (!mounted) return;

    setState(() {
      _detectados = lista;
      _lendo = false;
    });
  }

  void _adicionar(Medicamento medicamento) {
    final adicionado = widget.aoAdicionar(medicamento);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            adicionado
                ? '${medicamento.nome} adicionado à sua rotina.'
                : '${medicamento.nome} já está na sua rotina.',
          ),
        ),
      );
  }

  void _adicionarTodos() {
    var novos = 0;

    for (final medicamento in _detectados) {
      if (widget.aoAdicionar(medicamento)) novos++;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            novos == 0
                ? 'Todos os medicamentos já estavam cadastrados.'
                : '$novos medicamento(s) adicionado(s) à sua rotina.',
          ),
        ),
      );
  }

  bool _jaAdicionado(Medicamento medicamento) {
    return widget.medicamentos.any((item) => item.id == medicamento.id);
  }

  @override
  Widget build(BuildContext context) {
    final todosAdicionados =
        _detectados.isNotEmpty && _detectados.every(_jaAdicionado);

    return Column(
      children: [
        Container(
          color: Cores.primariaEscura,
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
          child: Row(
            children: [
              const SizedBox(width: 44),
              const Expanded(
                child: Text(
                  'Ler Receita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Ler outra receita',
                onPressed: _lendo ? null : _lerReceita,
                icon: Icon(
                  Icons.refresh_rounded,
                  color: _lendo ? Colors.white38 : Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 268,
          child: Container(
            color: const Color(0xFF0A0A1A),
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Container(
                width: 270,
                height: 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Cores.azulClaro, width: 2.5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/receita.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: _lendo
                ? estadoLendo()
                : _resultadoLeitura(todosAdicionados),
          ),
        ),
      ],
    );
  }

  Widget _resultadoLeitura(bool todosAdicionados) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F8EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 20,
                color: Color(0xFF1B9C55),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leitura concluída',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Revise os medicamentos encontrados:',
                    style: TextStyle(fontSize: 11, color: Color(0xFF8B94A3)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final medicamento in _detectados)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: cartaoMedicamento(
              medicamento: medicamento,
              acao: IconButton(
                tooltip: 'Adicionar à rotina',
                onPressed: _jaAdicionado(medicamento)
                    ? null
                    : () => _adicionar(medicamento),
                icon: Icon(
                  _jaAdicionado(medicamento)
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_rounded,
                  color: _jaAdicionado(medicamento)
                      ? const Color(0xFF1B9C55)
                      : Cores.primaria,
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        botaoApp(
          texto: todosAdicionados
              ? 'Todos adicionados'
              : 'Adicionar todos à rotina',
          icone: Icons.playlist_add_check_rounded,
          onPressed: todosAdicionados ? null : _adicionarTodos,
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: _lerReceita,
          style: TextButton.styleFrom(foregroundColor: Cores.primaria),
          child: const Text(
            'Ler outra receita',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

Widget estadoLendo() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(
        width: 34,
        height: 34,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Cores.azulClaro),
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'Lendo sua receita...',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Text(
        'Identificando medicamentos, dosagens e horários.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          color: Colors.grey.shade500,
          height: 1.5,
        ),
      ),
    ],
  );
}
