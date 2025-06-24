import 'package:flutter/material.dart';

class CardRefazerSenha extends StatelessWidget {
  final TextEditingController cpfController;
  final TextEditingController novaSenhaController;
  final TextEditingController repetirSenhaController;
  final TextEditingController codigoSmsController;
  final VoidCallback onEnviarSms;

  const CardRefazerSenha({
    super.key,
    required this.cpfController,
    required this.novaSenhaController,
    required this.repetirSenhaController,
    required this.codigoSmsController,
    required this.onEnviarSms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        campoTexto('CPF', cpfController),
        const SizedBox(height: 15),
        campoTexto('NOVA SENHA', novaSenhaController, obscure: true),
        const SizedBox(height: 15),
        campoTexto('REPETIR SENHA', repetirSenhaController, obscure: true),
        const SizedBox(height: 20),

        const Text(
          'IREMOS ENVIAR UM CODIGO SMS PARA O TELEFONE CADASTRADO',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF359730)),
        ),
        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: onEnviarSms,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFECE6D9),
            foregroundColor: const Color(0xFF359730),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text('ENVIAR', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'ESCREVA O CODIGO RECEBIDO NO CAMPO',
          style: TextStyle(color: Color(0xFF359730)),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 50,
          child: TextField(
            controller: codigoSmsController,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              letterSpacing: 10,
              color: Color(0xFF359730),
              fontWeight: FontWeight.bold,
            ),
            maxLength: 6,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFB6DBB0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget campoTexto(String label, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF359730))),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFB6DBB0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
