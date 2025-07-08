// 📄 lib/widgets/card-cadastro.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardCadastro extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController nomeController;
  final TextEditingController sobrenomeController;
  final TextEditingController cpfController;
  final TextEditingController telefoneController;
  final TextEditingController senhaController;

  CardCadastro({
    super.key,
    required this.emailController,
    required this.nomeController,
    required this.sobrenomeController,
    required this.cpfController,
    required this.telefoneController,
    required this.senhaController,
  });

  final cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final phoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        campoTexto('EMAIL', emailController, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 15),
        campoTexto('NOME', nomeController, validator: _validaTexto),
        const SizedBox(height: 15),
        campoTexto('SOBRENOME', sobrenomeController, validator: _validaTexto),
        const SizedBox(height: 15),
        campoTexto('CPF', cpfController, keyboardType: TextInputType.number, validator: _validaCPF, inputFormatters: [cpfFormatter]),
        const SizedBox(height: 15),
        campoTexto('TELEFONE', telefoneController, keyboardType: TextInputType.phone, validator: _validaTexto, inputFormatters: [phoneFormatter]),
        const SizedBox(height: 15),
        campoTexto('SENHA', senhaController, obscure: true, validator: _validaSenha),
      ],
    );
  }

  Widget campoTexto(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF359730))),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatters,
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

  static String? _validaTexto(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? _validaCPF(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe o CPF';

    final cpfLimpo = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpfLimpo.length != 11) return 'CPF inválido';

    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfLimpo)) return 'CPF inválido';

    int calcDigito(List<int> numeros, int multiplicadorInicial) {
      var soma = 0;
      for (int i = 0; i < numeros.length; i++) {
        soma += numeros[i] * (multiplicadorInicial - i);
      }
      var resto = soma % 11;
      return resto < 2 ? 0 : 11 - resto;
    }

    final numeros = cpfLimpo.split('').map(int.parse).toList();
    final digito1 = calcDigito(numeros.sublist(0, 9), 10);
    final digito2 = calcDigito(numeros.sublist(0, 10), 11);

    if (numeros[9] != digito1 || numeros[10] != digito2) return 'CPF inválido';

    return null;
  }

  static String? _validaSenha(String? valor) {
    if (valor == null || valor.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
