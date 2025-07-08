import 'package:flutter/material.dart';
import '../services/auth-service.dart';
import '../widgets/card-refazer-senha.dart';

class RefazerSenhaScreen extends StatefulWidget {
  const RefazerSenhaScreen({super.key});

  @override
  State<RefazerSenhaScreen> createState() => _RefazerSenhaScreenState();
}

class _RefazerSenhaScreenState extends State<RefazerSenhaScreen> {
  final _authService = AuthService();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  String? email;
  bool camposHabilitados = false;
  bool codigoValidado = false;

  void showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> verificarCPF() async {
    final rawCpf = _cpfController.text.trim();
    final cpf = rawCpf.replaceAll(RegExp(r'[^0-9]'), '');

    final resultadoEmail = await _authService.buscarEmailPorCPF(cpf);
    if (resultadoEmail == null) {
      showSnack('CPF não encontrado');
      return;
    }

    email = resultadoEmail;

    final metodo = await _authService.verificarMetodoLogin(email!);
    if (metodo == 'google') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login com Google'),
          content: const Text(
            'Essa conta utiliza login com Google e não pode alterar senha aqui.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (metodo == 'email') {
      setState(() => camposHabilitados = true);
    } else {
      showSnack('Método de login não suportado.');
    }
  }

  Future<void> enviarCodigo() async {
    if (email == null) return;

    await _authService.enviarCodigoParaEmail(email!);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Verificação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Irá chegar um código de confirmação no e-mail:\n$email'),
            const SizedBox(height: 10),
            const Text('Escreva o código aqui:'),
            const SizedBox(height: 5),
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Código de verificação',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final valido = await _authService.verificarCodigoEmail(
                email!,
                _codigoController.text.trim(),
              );
              if (valido) {
                setState(() => codigoValidado = true);
                Navigator.pop(context);
                showSnack('Código confirmado. Agora você pode salvar a nova senha.');
              } else {
                showSnack('Código incorreto. Tente novamente.');
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> salvarSenha() async {
    if (!codigoValidado) return showSnack('Código não confirmado');

    final senha = _novaSenhaController.text.trim();
    final confirmar = _confirmarSenhaController.text.trim();
    if (senha != confirmar) return showSnack('As senhas não coincidem');

    final sucesso = await _authService.redefinirSenhaEFazerLogin(
      email!,
      senha,
      _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (sucesso) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnack('Erro ao redefinir senha');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refazer Senha')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarCPF,
              child: const Text('Verificar CPF'),
            ),
            const SizedBox(height: 20),
            if (camposHabilitados)
              CardRefazerSenha(
                novaSenhaController: _novaSenhaController,
                confirmarSenhaController: _confirmarSenhaController,
                onEnviarCodigo: enviarCodigo,
                onSalvarSenha: salvarSenha,
              ),
          ],
        ),
      ),
    );
  }
}
