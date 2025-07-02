import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarPerfilScreen extends StatefulWidget {
  final bool veioDoLogin;

  const EditarPerfilScreen({super.key, this.veioDoLogin = false});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

// --- FORMATADORES ---

// Máscara para CPF: 000.000.000-00
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 11) text = text.substring(0, 11);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Máscara para telefone: (00) 00000-0000
class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 11) text = text.substring(0, 11);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 7) buffer.write('-');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Função para formatar telefone para salvar no Firestore: "+55 XX XXXXXXXX"
String formatarTelefoneParaSalvar(String telefone) {
  final numeros = telefone.replaceAll(RegExp(r'[^0-9]'), '');

  if (numeros.length == 11) {
    final ddd = numeros.substring(0, 2);
    final numero = numeros.substring(2);
    return '+55 $ddd $numero';
  }

  return telefone; // ou pode lançar erro/avisar usuário
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _carregando = true;
  bool _salvando = false;
  bool _loginGoogle = false;

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final docId = prefs.getString('cpf');

    if (docId != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('pessoas')
              .doc(docId)
              .get();

      final dados = doc.data();
      if (dados != null) {
        _nomeController.text = dados['nome'] ?? '';
        _sobrenomeController.text = dados['sobrenome'] ?? '';
        _cpfController.text = dados['cpf'] ?? '';
        _telefoneController.text = dados['telefone'] ?? '';
        _emailController.text = dados['email'] ?? '';
        _senhaController.text = dados['senha'] ?? '';

        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.email == dados['email']) {
          _loginGoogle = true;
        }
      }
    }

    setState(() => _carregando = false);
  }

  Future<void> _salvarDados() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final prefs = await SharedPreferences.getInstance();
    final docId = prefs.getString('cpf');

    if (docId != null) {
      final docRef = FirebaseFirestore.instance
          .collection('pessoas')
          .doc(docId);

      final telefoneFormatado = formatarTelefoneParaSalvar(
        _telefoneController.text,
      );

      final dataToUpdate = {
        'nome': _nomeController.text.trim(),
        'sobrenome': _sobrenomeController.text.trim(),
        'cpf': _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        'telefone': telefoneFormatado,
        'senha': _senhaController.text.trim(),
      };

      if (!_loginGoogle) {
        dataToUpdate['email'] = _emailController.text.trim();
      }

      await docRef.update(dataToUpdate);

      await prefs.setString(
        'cpf',
        _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      if (widget.veioDoLogin) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pop(context);
      }
    }

    setState(() => _salvando = false);
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF2CAC50),
      ),
      body:
          _carregando
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const Text(
                          'Atualize suas informações:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),

                        // Nome
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Informe o nome'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        // Sobrenome
                        TextFormField(
                          controller: _sobrenomeController,
                          decoration: const InputDecoration(
                            labelText: 'Sobrenome',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CPF
                        TextFormField(
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CpfInputFormatter()],
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null ||
                                          value
                                                  .replaceAll(
                                                    RegExp(r'[^0-9]'),
                                                    '',
                                                  )
                                                  .length !=
                                              11
                                      ? 'CPF inválido'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        // Telefone
                        TextFormField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [TelefoneInputFormatter()],
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null ||
                                          value
                                                  .replaceAll(
                                                    RegExp(r'[^0-9]'),
                                                    '',
                                                  )
                                                  .length <
                                              10
                                      ? 'Telefone inválido'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        // E-mail (desabilitado se for login Google)
                        TextFormField(
                          controller: _emailController,
                          enabled: !_loginGoogle,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!_loginGoogle &&
                                (value == null || !value.contains('@'))) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        if (_loginGoogle)
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'O e-mail é gerenciado pelo Google e não pode ser alterado.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Senha (desabilitado se login Google)
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          enabled: !_loginGoogle,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!_loginGoogle &&
                                (value == null || value.isEmpty)) {
                              return 'Informe a senha';
                            }
                            return null;
                          },
                        ),

                        if (_loginGoogle)
                          const Padding(
                            padding: EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'A senha é gerenciada pelo Google e não pode ser alterada.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: _salvando ? null : _salvarDados,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2CAC50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:
                              _salvando
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text('Salvar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
