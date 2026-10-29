class Endereco {
  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
    this.complemento = '',
  });

  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;
  final String complemento;

  bool get valido => cidade.isNotEmpty && uf.isNotEmpty;

  String get linhaCompleta {
    return '$logradouro, $bairro, $cidade - $uf';
  }

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: (json['cep'] as String? ?? '').trim(),
      logradouro: (json['logradouro'] as String? ?? '').trim(),
      bairro: (json['bairro'] as String? ?? '').trim(),
      cidade: (json['localidade'] as String? ?? '').trim(),
      uf: (json['uf'] as String? ?? '').trim(),
      complemento: (json['complemento'] as String? ?? '').trim(),
    );
  }
}
