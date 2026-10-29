import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/endereco.dart';

class ViaCepException implements Exception {
  const ViaCepException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

class ViaCepService {
  Future<Endereco?> buscar(String cep) async {
    final digitos = cep.replaceAll(RegExp(r'\D'), '');

    if (digitos.length != 8) {
      throw const ViaCepException('Digite um CEP com 8 dígitos.');
    }

    final url = Uri.parse('https://viacep.com.br/ws/$digitos/json/');

    try {
      final resposta = await http.get(url);

      if (resposta.statusCode != 200) {
        throw const ViaCepException('Serviço de CEP indisponível.');
      }

      final dados = json.decode(resposta.body);

      if (dados['erro'] == true || dados['erro'] == 'true') {
        return null;
      }

      return Endereco.fromJson(dados);
    } on ViaCepException {
      rethrow;
    } catch (erro) {
      throw const ViaCepException(
        'Não foi possível consultar o CEP. Verifique sua conexão.',
      );
    }
  }
}
