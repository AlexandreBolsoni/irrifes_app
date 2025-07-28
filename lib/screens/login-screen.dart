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
  final TextEditingController loginController = TextEditingController();
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
    final login = loginController.text.trim();
    final senha = senhaController.text.trim();

    String? email;
    String? cpf;

    if (RegExp(r'^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$').hasMatch(login)) {
      cpf = login.replaceAll(RegExp(r'\D'), '');
    } else {
      email = login;
    }

    _isLoading.value = true;

    final sucesso = await _authService.entrar(
      email: email,
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
        const SnackBar(content: Text('Login ou senha inválidos')),
      );
    }
  }

  void loginComGoogle(BuildContext context) async {
    _isLoading.value = true;

    final sucesso = await _authService.loginComGoogle(context);

    _isLoading.value = false;

    if (sucesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao entrar com o Google')),
      );
    }
  }

  void cadastrarComEmail(BuildContext context) {
    Navigator.pushNamed(context, '/cadastro');
  }

  void refazerSenha(BuildContext context) {
    Navigator.pushNamed(context, '/refazer-senha');
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
                    loginController: loginController,
                    senhaController: senhaController,
                    onEntrar: () => entrar(context),
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
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => loginComGoogle(context),
                    icon: Image.asset(
                      'assets/img/g-logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      'Entrar com o Google',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                      onPressed: () => cadastrarComEmail(context),
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
                    onTap: () => refazerSenha(context),
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
