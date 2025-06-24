import 'package:flutter/material.dart';
import '../widgets/bottom-nav.dart';  // ajuste o caminho conforme seu projeto

class CalcularScreen extends StatefulWidget {
  const CalcularScreen({Key? key}) : super(key: key);

  @override
  State<CalcularScreen> createState() => _CalcularScreenState();
}

class _CalcularScreenState extends State<CalcularScreen> {
  int _currentIndex = 1; // índice da aba "Calcular"

  void _novaArea(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NovaAreaScreen()),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return; // se clicar na mesma aba, não faz nada
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // já estamos no calcular
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular'),
        backgroundColor: const Color(0xFF2CAC50),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2CAC50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Selecione a Área',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _novaArea(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CAC50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Nova Área'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

class NovaAreaScreen extends StatelessWidget {
  const NovaAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Área'),
        backgroundColor: const Color(0xFF2CAC50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text('Nome da Área:', style: TextStyle(color: Colors.green)),
              Divider(),
              SizedBox(height: 16),
              Text('Tipo de Terreno:', style: TextStyle(color: Colors.green)),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilterChip(label: Text('Arenoso'), selected: false, onSelected: null),
                  FilterChip(label: Text('Argila'), selected: false, onSelected: null),
                  FilterChip(label: Text('Argila'), selected: false, onSelected: null),
                  FilterChip(label: Text('Argila'), selected: false, onSelected: null),
                  FilterChip(label: Text('Arenoso'), selected: false, onSelected: null),
                  FilterChip(label: Text('Argila'), selected: false, onSelected: null),
                ],
              ),
              SizedBox(height: 20),
              Text('Espaçamento entre Linhas', style: TextStyle(color: Colors.green)),
              Divider(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF2CAC50)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                child: Text('SALVAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
