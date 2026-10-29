enum PeriodoMedicamento {
  manha('Manhã', '☀️'),
  tarde('Tarde', '☀️'),
  noite('Noite', '🌙');

  const PeriodoMedicamento(this.rotulo, this.emoji);

  final String rotulo;
  final String emoji;
}

class Medicamento {
  const Medicamento({
    required this.id,
    required this.nome,
    required this.dosagem,
    required this.horario,
    required this.periodo,
    this.concluido = false,
    this.estoqueDias,
  });

  final String id;
  final String nome;
  final String dosagem;
  final String horario;
  final PeriodoMedicamento periodo;
  final bool concluido;
  final int? estoqueDias;

  Medicamento copiarCom({bool? concluido}) {
    return Medicamento(
      id: id,
      nome: nome,
      dosagem: dosagem,
      horario: horario,
      periodo: periodo,
      concluido: concluido ?? this.concluido,
      estoqueDias: estoqueDias,
    );
  }
}
