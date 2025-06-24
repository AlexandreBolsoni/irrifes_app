import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardLogin extends StatefulWidget {
  final TextEditingController cpfController;
  final TextEditingController senhaController;
  final VoidCallback onEntrar;
  final VoidCallback onCadastrar;
  final VoidCallback onPressed;

  const CardLogin({
    super.key,
    required this.cpfController,
    required this.senhaController,
    required this.onEntrar,
    required this.onCadastrar,
    required this.onPressed,
  });

  @override
  State<CardLogin> createState() => _CardLoginState();
}

class _CardLoginState extends State<CardLogin> {
  final cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  bool mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CPF',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.cpfController,
          keyboardType: TextInputType.number,
          inputFormatters: [cpfFormatter],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'SENHA',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.senhaController,
          obscureText: !mostrarSenha,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            suffixIcon: IconButton(
              icon: Icon(
                mostrarSenha ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF359730),
              ),
              onPressed: () {
                setState(() {
                  mostrarSenha = !mostrarSenha;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: SizedBox(
            width: 130,
            child: ElevatedButton(
              onPressed: widget.onEntrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF359730),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('ENTRAR'),
            ),
          ),
        ),
        const SizedBox(height: 10),

      ],
    );
  }
}
