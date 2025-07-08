// 📄 lib/screens/cadastro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/card-cadastro.dart';
import '../services/auth-service.dart';

class CadastroScreen extends StatelessWidget {
  CadastroScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void cadastrar(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authService = AuthService();

    final sucesso = await authService.cadastrarComEmail(
      context: context,
      email: emailController.text.trim(),
      senha: senhaController.text.trim(),
      nome: nomeController.text.trim(),
      sobrenome: sobrenomeController.text.trim(),
      cpf: cpfController.text.trim(),
      telefone: telefoneController.text.trim(),
    );

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFDCEFD9),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: Container(
                        height: height * 0.25,
                        color: const Color(0xFF359730),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/img/logo-branca.svg',
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => const Text(
                              'Carregando...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'CADASTRO',
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF359730),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CardCadastro(
                      emailController: emailController,
                      nomeController: nomeController,
                      sobrenomeController: sobrenomeController,
                      cpfController: cpfController,
                      telefoneController: telefoneController,
                      senhaController: senhaController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              color: const Color(0xFFDCEFD9),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => cadastrar(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF359730),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CRIAR CONTA',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
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