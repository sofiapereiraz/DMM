class Usuario {
  const Usuario({
    required this.nome,
    required this.email,
    this.cep = '',
    this.endereco = '',
  });

  final String nome;
  final String email;
  final String cep;
  final String endereco;

  String get primeiroNome {
    final partes = nome.trim().split(' ');
    return partes.first;
  }
}
