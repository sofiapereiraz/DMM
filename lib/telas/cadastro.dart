import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../models/endereco.dart';
import '../componentes/comuns.dart';
import '../componentes/formulario.dart';
import '../services/autenticacao_service.dart';
import '../services/viacep_service.dart';
import 'entrada.dart';
import 'principal.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _cep = TextEditingController();
  final _rua = TextEditingController();
  final _bairro = TextEditingController();
  final _cidade = TextEditingController();

  final _viaCep = ViaCepService();
  final _auth = AutenticacaoService();

  Endereco? _endereco;
  String? _ultimoCep;
  bool _carregandoCep = false;
  bool _carregandoCadastro = false;

  String? _erroNome;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroCep;

  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _cep.dispose();
    _rua.dispose();
    _bairro.dispose();
    _cidade.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _buscarCep([String? valor]) async {
    final digitos = (valor ?? _cep.text).replaceAll(RegExp(r'\D'), '');

    if (digitos.length != 8) {
      _mostrarMensagem('Digite um CEP com 8 dígitos para buscar o endereço.');
      return;
    }

    if (_carregandoCep || _ultimoCep == digitos) return;

    _ultimoCep = digitos;
    setState(() => _carregandoCep = true);

    try {
      final endereco = await _viaCep.buscar(digitos);
      if (!mounted) return;

      if (endereco == null) {
        setState(() {
          _endereco = null;
          _rua.clear();
          _bairro.clear();
          _cidade.clear();
        });
        _mostrarMensagem('CEP não encontrado. Confira os números digitados.');
      } else {
        setState(() {
          _endereco = endereco;
          _rua.text = endereco.logradouro;
          _bairro.text = endereco.bairro;
          _cidade.text = '${endereco.cidade} - ${endereco.uf}';
        });
        _mostrarMensagem('Endereço preenchido automaticamente via ViaCEP.');
      }
    } on ViaCepException catch (erro) {
      if (!mounted) return;
      _ultimoCep = null;
      _mostrarMensagem(erro.mensagem);
    } finally {
      if (mounted) setState(() => _carregandoCep = false);
    }
  }

  bool _validar() {
    final nome = _nome.text.trim();
    final email = _email.text.trim();
    final senha = _senha.text;
    final cep = _cep.text.replaceAll(RegExp(r'\D'), '');

    setState(() {
      _erroNome = nome.length < 3 ? 'Informe seu nome completo.' : null;
      _erroEmail = email.isEmpty
          ? 'Informe seu e-mail.'
          : !email.contains('@')
          ? 'Digite um e-mail válido.'
          : null;
      _erroSenha = senha.length < 4
          ? 'A senha precisa ter 4 caracteres ou mais.'
          : null;
      _erroCep = cep.length != 8 ? 'Informe um CEP com 8 dígitos.' : null;
    });

    return _erroNome == null &&
        _erroEmail == null &&
        _erroSenha == null &&
        _erroCep == null;
  }

  Future<void> _cadastrar() async {
    if (!_validar()) return;

    if (_endereco == null) {
      _mostrarMensagem('Busque um CEP válido antes de criar a conta.');
      return;
    }

    setState(() => _carregandoCadastro = true);

    final usuario = await _auth.cadastrar(
      nome: _nome.text,
      email: _email.text,
      cep: _cep.text,
      endereco: _endereco,
    );

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Principal(usuario: usuario)),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.azulProfundo,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundo_auth.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
              child: Row(
                children: [
                  botaoVoltar(onPressed: () => Navigator.of(context).pop()),
                  const Expanded(child: SizedBox()),
                  logoMedMind(largura: 150),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xF2EAF5FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Crie sua conta',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Preencha seus dados e informe o CEP para '
                        'buscarmos seu endereço.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5B6B80),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      campoTexto(
                        rotulo: 'Nome',
                        controlador: _nome,
                        dica: 'Seu nome completo',
                        capitalizacao: TextCapitalization.words,
                        erro: _erroNome,
                      ),
                      const SizedBox(height: 16),
                      campoTexto(
                        rotulo: 'E-mail',
                        controlador: _email,
                        dica: 'voce@email.com',
                        teclado: TextInputType.emailAddress,
                        erro: _erroEmail,
                      ),
                      const SizedBox(height: 16),
                      campoTexto(
                        rotulo: 'Senha',
                        controlador: _senha,
                        dica: '••••••••',
                        senha: true,
                        erro: _erroSenha,
                      ),
                      const SizedBox(height: 16),
                      campoTexto(
                        rotulo: 'CEP',
                        controlador: _cep,
                        dica: '00000000',
                        teclado: TextInputType.number,
                        erro: _erroCep,
                        sufixo: _carregandoCep
                            ? const Padding(
                                padding: EdgeInsets.all(13),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                  ),
                                ),
                              )
                            : IconButton(
                                tooltip: 'Buscar CEP',
                                onPressed: _buscarCep,
                                icon: const Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: Cores.primaria,
                                ),
                              ),
                        aoMudar: (valor) {
                          if (valor.length == 8) {
                            _buscarCep(valor);
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'O endereço é preenchido automaticamente '
                        'pela API ViaCEP (JSON).',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF7C8798),
                        ),
                      ),
                      if (_endereco != null) ...[
                        const SizedBox(height: 16),
                        campoTexto(
                          rotulo: 'Rua',
                          controlador: _rua,
                          somenteLeitura: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: campoTexto(
                                rotulo: 'Bairro',
                                controlador: _bairro,
                                somenteLeitura: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: campoTexto(
                                rotulo: 'Cidade / UF',
                                controlador: _cidade,
                                somenteLeitura: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      botaoApp(
                        texto: 'Criar conta',
                        carregando: _carregandoCadastro,
                        onPressed: _cadastrar,
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Cores.primaria,
                        ),
                        child: const Text(
                          'Já tenho uma conta · Entrar',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
