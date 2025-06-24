import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/area-model.dart';

class AreaCard extends StatelessWidget {
  final AreaData area;

  const AreaCard({Key? key, required this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${area.nome}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Terreno: ${area.tipoTerreno}'),
            Text('Data: ${area.dataCalculo}'),
            const SizedBox(height: 10),
            const Text('Gráfico U Calc'),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: area.pontosUCalc,
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Curva de Retenção'),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: area.pontosRetencao,
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.green,
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tempo necessário: 3 Horas e 42 Minutos',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
