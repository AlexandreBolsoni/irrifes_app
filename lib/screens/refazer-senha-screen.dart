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
  final _cpfController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _codigoController = TextEditingController();

  String? email;
  bool camposHabilitados = false;
  bool codigoValidado = false;
  bool carregando = false;

  void showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> verificarCPF() async {
    final rawCpf = _cpfController.text.trim();
    final cpf = rawCpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return showSnack('CPF inválido');

    setState(() {
      carregando = true;
      camposHabilitados = false;
      email = null;
      codigoValidado = false;
    });

    final resultadoEmail = await _authService.buscarEmailPorCPF(cpf);
    if (resultadoEmail == null) {
      setState(() => carregando = false);
      return showSnack('CPF não encontrado');
    }

    email = resultadoEmail;
    final metodo = await _authService.verificarMetodoLogin(email!);

    setState(() {
      carregando = false;
    });

    if (metodo == 'google') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login com Google'),
          content: const Text('Essa conta usa Google e não pode redefinir a senha aqui.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
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

    final enviado = await _authService.enviarCodigoParaEmail(email!);
    if (!enviado) return showSnack('Erro ao enviar código');

    showSnack('Código enviado para $email');
  }

  Future<void> salvarSenha() async {
    if (!codigoValidado) {
      final valido = await _authService.verificarCodigoEmail(
        email!,
        _codigoController.text.trim(),
      );
      if (!valido) return showSnack('Código inválido');
      setState(() => codigoValidado = true);
    }

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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: carregando ? null : verificarCPF,
              child: carregando
                  ? const CircularProgressIndicator()
                  : const Text('Verificar CPF'),
            ),
            const SizedBox(height: 20),
            if (camposHabilitados)
              CardRefazerSenha(
                novaSenhaController: _novaSenhaController,
                confirmarSenhaController: _confirmarSenhaController,
                codigoController: _codigoController,
                onEnviarCodigo: enviarCodigo,
                onSalvarSenha: salvarSenha,
              ),
          ],
        ),
      ),
    );
  }
}
