import 'package:flutter/material.dart';

class CardRefazerSenha extends StatelessWidget {
  final TextEditingController novaSenhaController;
  final TextEditingController confirmarSenhaController;
  final TextEditingController codigoController;
  final VoidCallback onEnviarCodigo;
  final VoidCallback onSalvarSenha;
  final bool carregandoSalvarSenha;

  const CardRefazerSenha({
    super.key,
    required this.novaSenhaController,
    required this.confirmarSenhaController,
    required this.codigoController,
    required this.onEnviarCodigo,
    required this.onSalvarSenha,
    required this.carregandoSalvarSenha,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onEnviarCodigo,
          child: const Text('Enviar Código por E-mail'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: codigoController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Código de verificação'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSalvarSenha,
          child: carregandoSalvarSenha
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Salvar Nova Senha'),
        ),
      ],
    );
  }
}
