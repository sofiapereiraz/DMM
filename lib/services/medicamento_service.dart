import '../models/medicamento.dart';

class MedicamentoService {
  const MedicamentoService();

  List<Medicamento> carregarIniciais() {
    return const [
      Medicamento(
        id: 'losartana-08',
        nome: 'Losartana 50mg',
        dosagem: '1 comprimido',
        horario: '08:00',
        periodo: PeriodoMedicamento.manha,
        estoqueDias: 5,
      ),
      Medicamento(
        id: 'metformina-12',
        nome: 'Metformina 850mg',
        dosagem: '1 comprimido',
        horario: '12:00',
        periodo: PeriodoMedicamento.tarde,
      ),
      Medicamento(
        id: 'dipirona-20',
        nome: 'Dipirona 500mg',
        dosagem: '1 comprimido',
        horario: '20:00',
        periodo: PeriodoMedicamento.noite,
      ),
    ];
  }

  Future<List<Medicamento>> lerReceita() async {
    await Future.delayed(const Duration(seconds: 3));

    return const [
      Medicamento(
        id: 'amoxicilina-08',
        nome: 'Amoxicilina 500mg',
        dosagem: '1 cápsula',
        horario: '08:00',
        periodo: PeriodoMedicamento.manha,
      ),
      Medicamento(
        id: 'ibuprofeno-12',
        nome: 'Ibuprofeno 400mg',
        dosagem: '1 comprimido',
        horario: '12:00',
        periodo: PeriodoMedicamento.tarde,
      ),
      Medicamento(
        id: 'omeprazol-20',
        nome: 'Omeprazol 20mg',
        dosagem: '1 cápsula',
        horario: '20:00',
        periodo: PeriodoMedicamento.noite,
      ),
    ];
  }
}
