import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';
import '../componentes/cartoes.dart';
import '../componentes/comuns.dart';
import '../componentes/dia.dart';
import '../componentes/formulario.dart';

class Lembretes extends StatefulWidget {
  const Lembretes({
    super.key,
    required this.medicamentos,
    required this.aoAdicionar,
    required this.aoAlternar,
    required this.aoAbrirMedicamento,
  });

  final List<Medicamento> medicamentos;
  final bool Function(Medicamento) aoAdicionar;
  final ValueChanged<String> aoAlternar;
  final ValueChanged<Medicamento> aoAbrirMedicamento;

  @override
  State<Lembretes> createState() => _LembretesState();
}

class _LembretesState extends State<Lembretes> {
  late List<DateTime> _semana;
  late DateTime _diaSelecionado;

  void initState() {
    super.initState();

    final hoje = DateTime.now();
    final segunda = hoje.subtract(Duration(days: hoje.weekday - 1));
    _semana = List.generate(
      7,
      (indice) => DateTime(segunda.year, segunda.month, segunda.day + indice),
    );
    _diaSelecionado = DateTime(hoje.year, hoje.month, hoje.day);
  }

  Future<void> _adicionarMedicamento() async {
    final novo = await showDialog<Medicamento>(
      context: context,
      builder: (_) => const DialogoNovoMedicamento(),
    );

    if (novo == null || !mounted) return;

    final adicionado = widget.aoAdicionar(novo);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            adicionado
                ? '${novo.nome} adicionado aos lembretes.'
                : '${novo.nome} já está cadastrado.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final ordenados = [...widget.medicamentos]
      ..sort((a, b) => a.horario.compareTo(b.horario));

    Medicamento? proximo;
    for (final medicamento in ordenados) {
      if (!medicamento.concluido) {
        proximo = medicamento;
        break;
      }
    }

    final hoje = DateTime.now();
    final ehHoje =
        _diaSelecionado.year == hoje.year &&
        _diaSelecionado.month == hoje.month &&
        _diaSelecionado.day == hoje.day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Lembretes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: 'Novo medicamento',
                onPressed: _adicionarMedicamento,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Cores.primaria,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF3FF),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                for (final data in _semana)
                  diaCalendario(
                    data: data,
                    selecionado:
                        data.year == _diaSelecionado.year &&
                        data.month == _diaSelecionado.month &&
                        data.day == _diaSelecionado.day,
                    onTap: () {
                      setState(() {
                        _diaSelecionado = DateTime(
                          data.year,
                          data.month,
                          data.day,
                        );
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
          child: Text(
            '${ehHoje ? 'Hoje' : 'Dia'}, '
            '${formatarDataCurta(_diaSelecionado)}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              if (ordenados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(
                      'Nenhum medicamento para este dia.',
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
                      onTap: () => widget.aoAbrirMedicamento(medicamento),
                      acao: IconButton(
                        tooltip: medicamento.concluido
                            ? 'Desmarcar'
                            : 'Marcar como tomado',
                        onPressed: () => widget.aoAlternar(medicamento.id),
                        icon: Icon(
                          medicamento.concluido
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: medicamento.concluido
                              ? Cores.primaria
                              : const Color(0xFFC0C4D0),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 8),
              cartaoDica(
                icone: Icons.health_and_safety_rounded,
                titulo: proximo == null
                    ? 'Tudo em dia! Nenhum medicamento pendente.'
                    : 'Seu próximo medicamento é às ${proximo.horario}',
                subtitulo: proximo?.nome,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DialogoNovoMedicamento extends StatefulWidget {
  const DialogoNovoMedicamento({super.key});

  @override
  State<DialogoNovoMedicamento> createState() => _DialogoNovoMedicamentoState();
}

class _DialogoNovoMedicamentoState extends State<DialogoNovoMedicamento> {
  final _nome = TextEditingController();
  final _dosagem = TextEditingController(text: '1 comprimido');
  final _horario = TextEditingController();

  String? _erroNome;
  String? _erroDosagem;
  String? _erroHorario;

  void dispose() {
    _nome.dispose();
    _dosagem.dispose();
    _horario.dispose();
    super.dispose();
  }

  void _salvar() {
    final nome = _nome.text.trim();
    final dosagem = _dosagem.text.trim();
    final horario = _horario.text.trim();
    final formato = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

    setState(() {
      _erroNome = nome.isEmpty ? 'Informe o nome do medicamento.' : null;
      _erroDosagem = dosagem.isEmpty ? 'Informe a dosagem.' : null;
      _erroHorario = formato.hasMatch(horario)
          ? null
          : 'Digite o horário no formato 08:00.';
    });

    if (_erroNome != null || _erroDosagem != null || _erroHorario != null) {
      return;
    }

    final hora = int.parse(horario.split(':').first);
    PeriodoMedicamento periodo;
    if (hora < 12) {
      periodo = PeriodoMedicamento.manha;
    } else if (hora < 18) {
      periodo = PeriodoMedicamento.tarde;
    } else {
      periodo = PeriodoMedicamento.noite;
    }

    final medicamento = Medicamento(
      id: 'medicamento-${DateTime.now().microsecondsSinceEpoch}',
      nome: nome,
      dosagem: dosagem,
      horario: horario,
      periodo: periodo,
    );

    Navigator.of(context).pop(medicamento);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Novo medicamento',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            campoTexto(
              rotulo: 'Nome',
              controlador: _nome,
              dica: 'Ex.: Vitamina D',
              capitalizacao: TextCapitalization.words,
              erro: _erroNome,
            ),
            const SizedBox(height: 14),
            campoTexto(
              rotulo: 'Dosagem',
              controlador: _dosagem,
              dica: 'Ex.: 1 comprimido',
              erro: _erroDosagem,
            ),
            const SizedBox(height: 14),
            campoTexto(
              rotulo: 'Horário',
              controlador: _horario,
              dica: '08:00',
              teclado: TextInputType.datetime,
              erro: _erroHorario,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        SizedBox(
          width: 130,
          child: botaoApp(texto: 'Adicionar', onPressed: _salvar),
        ),
      ],
    );
  }
}
