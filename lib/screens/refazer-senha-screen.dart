import 'package:flutter/material.dart';
import '../widgets/card-refazer-senha.dart';

class RefazerSenhaScreen extends StatelessWidget {
  RefazerSenhaScreen({super.key});

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController repetirSenhaController = TextEditingController();
  final TextEditingController codigoSmsController = TextEditingController();

  void enviarSms() {
    // Lógica para enviar SMS
    print("Enviando SMS para número associado ao CPF...");
  }

  void salvarNovaSenha(BuildContext context) {
    // Lógica para validar código e salvar nova senha
    print("Salvando nova senha...");
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      height: height * 0.25,
                      color: const Color(0xFF359730),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'REFAZER SENHA',
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      color: Color(0xFF359730),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  CardRefazerSenha(
                    cpfController: cpfController,
                    novaSenhaController: novaSenhaController,
                    repetirSenhaController: repetirSenhaController,
                    codigoSmsController: codigoSmsController,
                    onEnviarSms: enviarSms,
                  ),
                ],
              ),
            ),
          ),

          // Botão Salvar
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
                  onPressed: () => salvarNovaSenha(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF359730),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'SALVAR',
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
