import 'package:flutter/material.dart';

class CardRefazerSenha extends StatelessWidget {
  final TextEditingController novaSenhaController;
  final TextEditingController confirmarSenhaController;
  final TextEditingController codigoController;
  final VoidCallback onEnviarCodigo;
  final VoidCallback onSalvarSenha;

  const CardRefazerSenha({
    super.key,
    required this.novaSenhaController,
    required this.confirmarSenhaController,
    required this.codigoController,
    required this.onEnviarCodigo,
    required this.onSalvarSenha,
  });

  @override
  Widget build(BuildContext context) {
/*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the widget tree for password reset card.
  ///
  /// This widget displays input fields for entering a new password, confirming
  /// the password, and a verification code. It also includes buttons for sending
  /// the verification code via email and saving the new password. The [novaSenhaController],
  /// [confirmarSenhaController], and [codigoController] are used to manage the text input
  /// for the new password, password confirmation, and verification code respectively.
  /// The [onEnviarCodigo] callback is triggered when the "Enviar Código por E-mail"
  /// button is pressed, and [onSalvarSenha] is triggered when the "Salvar Nova Senha"
  /// button is pressed.

/*******  c63a4480-e125-4f43-a384-43d652472692  *******/    return Column(
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
          child: const Text('Salvar Nova Senha'),
        ),
      ],
    );
  }
}
