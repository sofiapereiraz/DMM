import '../models/endereco.dart';
import '../models/usuario.dart';

class AutenticacaoService {
  Future<Usuario> entrar({required String email, required String senha}) async {
    await Future.delayed(const Duration(milliseconds: 650));

    final apelido = email.split('@').first.replaceAll('.', ' ').trim();
    final nome = apelido.isEmpty ? 'Paciente' : apelido;

    return Usuario(
      nome: nome[0].toUpperCase() + nome.substring(1),
      email: email.trim(),
    );
  }

  Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String cep,
    required Endereco? endereco,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));

    return Usuario(
      nome: nome.trim(),
      email: email.trim(),
      cep: cep,
      endereco: endereco?.linhaCompleta ?? '',
    );
  }
}
