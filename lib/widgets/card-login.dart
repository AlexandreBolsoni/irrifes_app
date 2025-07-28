import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardLogin extends StatefulWidget {
  final TextEditingController loginController;
  final TextEditingController senhaController;
  final VoidCallback onEntrar;

  const CardLogin({
    super.key,
    required this.loginController,
    required this.senhaController,
    required this.onEntrar,
  });

  @override
  State<CardLogin> createState() => _CardLoginState();
}

class _CardLoginState extends State<CardLogin> {
  bool mostrarSenha = false;
  bool isCpf = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void _atualizarFormato(String value) {
    final apenasNumeros = value.replaceAll(RegExp(r'\D'), '');

    setState(() {
      isCpf = apenasNumeros.length <= 11 && RegExp(r'^\d+$').hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'E-mail ou CPF',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.loginController,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: isCpf ? [cpfFormatter] : [],
          onChanged: _atualizarFormato,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Digite seu e-mail ou CPF',
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Senha',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.senhaController,
          obscureText: !mostrarSenha,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Digite sua senha',
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
      ],
    );
  }
}
