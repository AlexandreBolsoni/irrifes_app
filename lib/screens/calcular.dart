import 'package:flutter/material.dart';
import '../widgets/bottom-nav.dart';
import '../widgets/card-add-area.dart';
import '../services/area-service.dart';

class CalcularScreen extends StatefulWidget {
  const CalcularScreen({Key? key}) : super(key: key);

  @override
  State<CalcularScreen> createState() => _CalcularScreenState();
}

class _CalcularScreenState extends State<CalcularScreen> {
  int _currentIndex = 1;
  String? selectedAreaId;
  List<Map<String, dynamic>> areas = [];
  final AreaService _areaService = AreaService();

  @override
  void initState() {
    super.initState();
    fetchAreas();
  }

  Future<void> fetchAreas() async {
    final result = await _areaService.listarAreas();
    setState(() {
      areas = result;
    });
  }

  void _novaArea(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NovaAreaScreen()),
    ).then((_) => fetchAreas()); // Atualiza a lista ao voltar
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Já está na tela Calcular
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
              // Dropdown de áreas
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2CAC50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedAreaId,
                  hint: const Text(
                    'Selecione a Área',
                    style: TextStyle(color: Colors.white),
                  ),
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2CAC50),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  items: areas.map((area) {
                    return DropdownMenuItem<String>(
                      value: area['id'],
                      child: Text(
                        area['nomeArea'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAreaId = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Botão Nova Área
              ElevatedButton(
                onPressed: () => _novaArea(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CAC50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Nova Área'),
              ),

              const SizedBox(height: 12),

              // Botão Minhas Áreas
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/area');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Minhas Áreas'),
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

// Tela para criar nova área
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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CardAddArea(),
        ),
      ),
    );
  }
}
