import 'package:flutter/material.dart';

class CardCadastro extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController sobrenomeController;
  final TextEditingController cpfController;
  final TextEditingController telefoneController;
  final TextEditingController senhaController;
  final VoidCallback onCadastrar;

  const CardCadastro({
    super.key,
    required this.nomeController,
    required this.sobrenomeController,
    required this.cpfController,
    required this.telefoneController,
    required this.senhaController,
    required this.onCadastrar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        campoTexto('NOME', nomeController),
        const SizedBox(height: 15),
        campoTexto('SOBRENOME', sobrenomeController),
        const SizedBox(height: 15),
        campoTexto('CPF', cpfController),
        const SizedBox(height: 15),
        campoTexto('TELEFONE', telefoneController),
        const SizedBox(height: 15),
        campoTexto('SENHA', senhaController, obscure: true),
        const SizedBox(height: 25),
        SizedBox(
          width: 150,
         
        ),
      ],
    );
  }

  Widget campoTexto(String label, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF359730)),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFB6DBB0), // verde claro
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
