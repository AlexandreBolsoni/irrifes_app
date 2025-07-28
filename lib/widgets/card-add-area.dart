import 'package:flutter/material.dart';

class CardAddArea extends StatefulWidget {
  const CardAddArea({super.key});

  @override
  State<CardAddArea> createState() => _CardAddAreaState();
}

class _CardAddAreaState extends State<CardAddArea> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _linhaController = TextEditingController();
  final TextEditingController _plantaController = TextEditingController();

  final List<String> _tiposTerreno = [
    'Arenoso',
    'Argiloso',
    'Franco Arenoso',
    'Franco Argiloso',
  ];

  String? _terrenoSelecionado;

  void _salvarArea() {
    final nome = _nomeController.text.trim();
    final linha = double.tryParse(_linhaController.text.trim());
    final planta = double.tryParse(_plantaController.text.trim());

    if (nome.isEmpty || linha == null || planta == null || _terrenoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    // Aqui você pode salvar no Firestore, por exemplo
    print('Nome: $nome');
    print('Espaçamento Linha: $linha');
    print('Espaçamento Planta: $planta');
    print('Tipo de Terreno: $_terrenoSelecionado');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Área salva com sucesso!')),
    );

    // Limpar campos ou navegar
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nome da Área:', style: TextStyle(color: Colors.green)),
        TextField(
          controller: _nomeController,
          decoration: const InputDecoration(
            hintText: 'Ex: Lote 1',
          ),
        ),
        const SizedBox(height: 16),

        const Text('Tipo de Terreno:', style: TextStyle(color: Colors.green)),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _tiposTerreno.map((tipo) {
            return ChoiceChip(
              label: Text(tipo),
              selected: _terrenoSelecionado == tipo,
              selectedColor: const Color(0xFF2CAC50),
              onSelected: (_) {
                setState(() => _terrenoSelecionado = tipo);
              },
              labelStyle: TextStyle(
                color: _terrenoSelecionado == tipo ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
        const Text('Espaçamento entre Linhas (m)', style: TextStyle(color: Colors.green)),
        TextField(
          controller: _linhaController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'Ex: 1.0'),
        ),

        const SizedBox(height: 20),
        const Text('Espaçamento entre Plantas (m)', style: TextStyle(color: Colors.green)),
        TextField(
          controller: _plantaController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'Ex: 0.3'),
        ),

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _salvarArea,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2CAC50),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('SALVAR'),
        ),
      ],
    );
  }
}
