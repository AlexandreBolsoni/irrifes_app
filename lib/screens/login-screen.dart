import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/card-login.dart';
import '../widgets/card-loading.dart';
import '../services/auth-service.dart';
import 'home-screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final AuthService _authService = AuthService();

  bool manterLogado = false;

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final logado = prefs.getBool('logado') ?? false;
    if (logado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  void entrar(BuildContext context) async {
    final cpf = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    final senha = senhaController.text.trim();

    _isLoading.value = true;

    try {
      final sucesso = await _authService.entrar(
        cpf: cpf,
        senha: senha,
        manterLogado: manterLogado,
      );

      _isLoading.value = false;

      if (sucesso) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CPF ou senha inválidos')),
        );
      }
    } catch (e) {
      _isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: ${e.toString()}')),
      );
    }
  }

  void cadastrar(BuildContext context) {
    _authService.cadastrar(context);
  }

  void recuperarSenha(BuildContext context) {
    _authService.recuperarSenha(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF359730),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      height: height * 0.25,
                      color: const Color(0xFFDCEFD9),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/img/logo-verde.svg',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) => const Text(
                            'Carregando...',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ENTRADA',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CardLogin(
                    cpfController: cpfController,
                    senhaController: senhaController,
                    onEntrar: () => entrar(context),
                    onCadastrar: () => cadastrar(context),
                    onPressed: () => recuperarSenha(context),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    value: manterLogado,
                    onChanged: (value) {
                      setState(() {
                        manterLogado = value ?? false;
                      });
                    },
                    title: const Text(
                      'Manter-me logado',
                      style: TextStyle(color: Colors.white),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              color: const Color(0xFF359730),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => cadastrar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDCEFD9),
                        foregroundColor: const Color(0xFF359730),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => recuperarSenha(context),
                    child: const Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, _) {
              return LoadingOverlay(
                isLoading: isLoading,
                message: 'Entrando...',
              );
            },
          ),
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width * 0.5, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
