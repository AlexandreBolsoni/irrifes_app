import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/area-model.dart';
import '../widgets/card-area.dart';  // Ajuste o nome do arquivo se precisar
import '../widgets/bottom-nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<AreaData> areas = [
    AreaData(
      nome: 'Área 1',
      tipoTerreno: 'Argiloso',
      dataCalculo: '22/06/2025',
      pontosUCalc: [
        FlSpot(0, 30),
        FlSpot(400, 26),
        FlSpot(800, 22),
        FlSpot(1200, 20),
      ],
      pontosRetencao: [
        FlSpot(0, 27),
        FlSpot(300, 20),
        FlSpot(600, 16),
        FlSpot(1200, 13),
      ],
    ),
    AreaData(
      nome: 'Área 2',
      tipoTerreno: 'Brejo',
      dataCalculo: '23/06/2025',
      pontosUCalc: [
        FlSpot(0, 28),
        FlSpot(400, 23),
        FlSpot(800, 20),
        FlSpot(1200, 17),
      ],
      pontosRetencao: [
        FlSpot(0, 25),
        FlSpot(300, 19),
        FlSpot(600, 14),
        FlSpot(1200, 11),
      ],
    ),
    AreaData(
      nome: 'Área 3',
      tipoTerreno: 'Terra Vermelha',
      dataCalculo: '24/06/2025',
      pontosUCalc: [
        FlSpot(0, 35),
        FlSpot(400, 30),
        FlSpot(800, 27),
        FlSpot(1200, 24),
      ],
      pontosRetencao: [
        FlSpot(0, 32),
        FlSpot(300, 25),
        FlSpot(600, 20),
        FlSpot(1200, 17),
      ],
    ),
    AreaData(
      nome: 'Área 4',
      tipoTerreno: 'Arenoso',
      dataCalculo: '25/06/2025',
      pontosUCalc: [
        FlSpot(0, 22),
        FlSpot(400, 20),
        FlSpot(800, 17),
        FlSpot(1200, 14),
      ],
      pontosRetencao: [
        FlSpot(0, 18),
        FlSpot(300, 16),
        FlSpot(600, 13),
        FlSpot(1200, 10),
      ],
    ),
  ];

  AreaData? _selectedArea;

  @override
  void initState() {
    super.initState();
    _selectedArea = areas.first;
  }

   void _onBottomNavTap(int index) {
    if (index == _currentIndex) return; // evita reload se clicar na mesma aba

    setState(() {
      _currentIndex = index;
    });

    // navegação
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/calcular');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/perfil');
    }
    // 0 é home, já estamos aqui
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF2CAC50),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2CAC50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AreaData>(
                      isExpanded: true,
                      value: _selectedArea,
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      items: areas.map((area) {
                        return DropdownMenuItem(
                          value: area,
                          child: Text(
                            area.nome,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (area) {
                        setState(() {
                          _selectedArea = area;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Última Área Calculada',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedArea != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nome da Área: ${_selectedArea!.nome}",
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tipo de Terreno: ${_selectedArea!.tipoTerreno}",
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Data do cálculo: ${_selectedArea!.dataCalculo}",
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AreaCard(area: _selectedArea!),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'Tempo necessário:',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '3 Horas e 42 Minutos',
                            style: TextStyle(
                              color: Color(0xFF1B5E20),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
