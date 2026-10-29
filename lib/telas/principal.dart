import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/medicamento.dart';
import '../models/usuario.dart';
import '../componentes/barra.dart';
import '../services/medicamento_service.dart';
import 'camera.dart';
import 'inicio.dart';
import 'lembretes.dart';
import 'medicamento.dart';

class Principal extends StatefulWidget {
  const Principal({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _aba = 0;

  late List<Medicamento> _medicamentos;

  @override
  void initState() {
    super.initState();
    _medicamentos = [...const MedicamentoService().carregarIniciais()];
  }

  bool _contem(String id) {
    return _medicamentos.any((medicamento) => medicamento.id == id);
  }

  bool _adicionar(Medicamento medicamento) {
    if (_contem(medicamento.id)) return false;

    setState(() {
      _medicamentos.add(medicamento);
      _medicamentos.sort((a, b) => a.horario.compareTo(b.horario));
    });
    return true;
  }

  void _alternar(String id) {
    final indice = _medicamentos.indexWhere(
      (medicamento) => medicamento.id == id,
    );
    if (indice == -1) return;

    setState(() {
      _medicamentos[indice] = _medicamentos[indice].copiarCom(
        concluido: !_medicamentos[indice].concluido,
      );
    });
  }

  void _abrirMedicamento(Medicamento medicamento) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MedicamentoScreen(
          medicamento: medicamento,
          aoAlternar: () => _alternar(medicamento.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendentes = _medicamentos
        .where((medicamento) => !medicamento.concluido)
        .length;

    return Scaffold(
      backgroundColor: Cores.fundo,
      body: IndexedStack(
        index: _aba,
        children: [
          Inicio(
            usuario: widget.usuario,
            medicamentos: _medicamentos,
            pendentes: pendentes,
            onAbrirLembretes: () => setState(() => _aba = 2),
            onAbrirMedicamento: _abrirMedicamento,
          ),
          Camera(
            medicamentos: _medicamentos,
            aoAdicionar: _adicionar,
          ),
          Lembretes(
            medicamentos: _medicamentos,
            aoAdicionar: _adicionar,
            aoAlternar: _alternar,
            aoAbrirMedicamento: _abrirMedicamento,
          ),
        ],
      ),
      bottomNavigationBar: barraNavegacao(
        indiceAtual: _aba,
        onSelecionar: (indice) => setState(() => _aba = indice),
      ),
    );
  }
}
