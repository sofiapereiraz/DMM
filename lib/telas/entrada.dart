import 'package:flutter/material.dart';

import '../tema/tema.dart';
import '../componentes/comuns.dart';
import '../componentes/formulario.dart';
import '../services/autenticacao_service.dart';
import 'cadastro.dart';
import 'principal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _abrirLogin();
  }

  Future<void> _abrirLogin() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginWelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16166B),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundo_capa.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xD9FFFFFF)),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginWelcomeScreen extends StatelessWidget {
  const LoginWelcomeScreen({super.key});

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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/tagline_logo.png',
                    width: 140,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
              decoration: const BoxDecoration(
                color: Color(0xE6C9E5FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bem-vindo ao MedMind',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Cores.texto,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Organize sua rotina de medicamentos com a ajuda da IA.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Color(0xFF42526B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  botaoApp(
                    texto: 'Já sou cliente',
                    raio: 999,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LoginFormScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  botaoApp(
                    texto: 'Quero criar uma nova conta',
                    estilo: EstiloBotao.claro,
                    raio: 999,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CadastroScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _auth = AutenticacaoService();

  bool _carregando = false;
  String? _erroEmail;
  String? _erroSenha;

  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  bool _validar() {
    final email = _email.text.trim();
    final senha = _senha.text;

    setState(() {
      _erroEmail = email.isEmpty
          ? 'Informe seu e-mail.'
          : !email.contains('@')
          ? 'Digite um e-mail válido.'
          : null;
      _erroSenha = senha.length < 4
          ? 'A senha precisa ter 4 caracteres ou mais.'
          : null;
    });

    return _erroEmail == null && _erroSenha == null;
  }

  Future<void> _entrar() async {
    if (!_validar()) return;

    setState(() => _carregando = true);

    final usuario = await _auth.entrar(email: _email.text, senha: _senha.text);
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
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xF2EAF5FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Acesse sua conta',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seus medicamentos e lembretes esperam por você.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5B6B80),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 24),
                      botaoApp(
                        texto: 'Entrar',
                        carregando: _carregando,
                        onPressed: _entrar,
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CadastroScreen(),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Cores.primaria,
                        ),
                        child: const Text(
                          'Ainda não tenho conta · Criar agora',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Demonstração: use qualquer e-mail e senha.',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF7C8798),
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

Widget botaoVoltar({required VoidCallback onPressed}) {
  return IconButton(
    onPressed: onPressed,
    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
    style: IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(9),
    ),
  );
}
