import 'package:flutter/material.dart';
import '../services/area-service.dart';


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

  Future<void> _salvarArea() async {
    final nome = _nomeController.text.trim();
    final linha = double.tryParse(_linhaController.text.trim());
    final planta = double.tryParse(_plantaController.text.trim());

    if (nome.isEmpty || linha == null || planta == null || _terrenoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    try {
      await AreaService().criarArea(
        nomeArea: nome,
        entreLinha: linha,
        entrePlantas: planta,
        tipoTerreno: _terrenoSelecionado!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Área salva com sucesso!')),
      );

      Navigator.pop(context); // volta para a tela anterior após salvar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFDFF5E4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Cadastro de Nova Área',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Nome da Área', style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Identifique o lote ou plantação', style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 4),
            TextField(
              controller: _nomeController,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: _inputDecoration('Ex: Lote 01 - Milho Safra'),
            ),

            const SizedBox(height: 20),

            const Text('Tipo de Terreno', style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Escolha conforme análise do solo', style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: _tiposTerreno.map((tipo) {
                return ChoiceChip(
                  label: Text(
                    tipo,
                    style: TextStyle(
                      fontSize: 14,
                      color: _terrenoSelecionado == tipo ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _terrenoSelecionado == tipo,
                  selectedColor: const Color(0xFF2CAC50),
                  onSelected: (_) {
                    setState(() => _terrenoSelecionado = tipo);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            const Text('Espaçamento entre Linhas (m)', style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Distância entre fileiras de plantio', style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 4),
            TextField(
              controller: _linhaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: _inputDecoration('Ex: 0.9'),
            ),

            const SizedBox(height: 20),

            const Text('Espaçamento entre Plantas (m)', style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Distância entre plantas na mesma fileira', style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 4),
            TextField(
              controller: _plantaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: _inputDecoration('Ex: 0.3'),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvarArea,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CAC50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('SALVAR ÁREA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
