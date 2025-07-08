import 'package:flutter/material.dart';

class CardRefazerSenha extends StatelessWidget {
  final TextEditingController novaSenhaController;
  final TextEditingController confirmarSenhaController;
  final VoidCallback onEnviarCodigo;
  final VoidCallback onSalvarSenha;

  const CardRefazerSenha({
    super.key,
    required this.novaSenhaController,
    required this.confirmarSenhaController,
    required this.onEnviarCodigo,
    required this.onSalvarSenha,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: novaSenhaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Nova senha'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: confirmarSenhaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Confirmar senha'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onEnviarCodigo,
          child: const Text('Enviar Código por E-mail'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onSalvarSenha,
          child: const Text('Salvar Nova Senha'),
        ),
      ],
    );
  }
}
