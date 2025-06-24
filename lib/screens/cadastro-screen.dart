import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/card-cadastro.dart';

class CadastroScreen extends StatelessWidget {
  CadastroScreen({super.key});

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

void cadastrar(BuildContext context) async {
  final telefone = telefoneController.text.trim();

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: telefone,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar SMS: ${e.message}')),
      );
    },
    codeSent: (String verificationId, int? resendToken) {
      // Navegar para a tela onde ele insere o código
      Navigator.pushNamed(context, '/verificar-codigo', arguments: {
        'verificationId': verificationId,
        'dadosCadastro': {
          'nome': nomeController.text,
          'sobrenome': sobrenomeController.text,
          'cpf': cpfController.text,
          'senha': senhaController.text,
          'telefone': telefone,
        }
      });
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFDCEFD9), // fundo claro
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
                    nomeController: nomeController,
                    sobrenomeController: sobrenomeController,
                    cpfController: cpfController,
                    senhaController: senhaController,
                    onCadastrar: () {}, telefoneController: TextEditingController(),
                  ),
                ],
              ),
            ),
          ),

          // BOTÃO DE VOLTAR
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/'); // voltar para tela de login
              },
            ),
          ),

          // RODAPÉ COM BOTÃO
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              color: const Color(0xFFDCEFD9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
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
                ],
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
