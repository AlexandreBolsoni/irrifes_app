import 'package:flutter/material.dart';
import '../services/area-service.dart';

class MinhasAreasScreen extends StatefulWidget {
  const MinhasAreasScreen({super.key});

  @override
  State<MinhasAreasScreen> createState() => _MinhasAreasScreenState();
}

class _MinhasAreasScreenState extends State<MinhasAreasScreen> {
  final AreaService _areaService = AreaService();
  List<Map<String, dynamic>> areas = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Áreas'),
        backgroundColor: const Color(0xFF2CAC50),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(area['nomeArea']),
              subtitle: Text(
                  'Entre linhas: ${area['entreLinha']}, Entre plantas: ${area['entrePlantas']}, Tipo: ${area['tipoTerreno']}'),
            ),
          );
        },
      ),
    );
  }
}
