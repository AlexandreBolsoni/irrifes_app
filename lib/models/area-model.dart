import 'package:fl_chart/fl_chart.dart';

class AreaData {
  final String nome;
  final String tipoTerreno;
  final String dataCalculo;
  final List<FlSpot> pontosUCalc;
  final List<FlSpot> pontosRetencao;

  AreaData({
    required this.nome,
    required this.tipoTerreno,
    required this.dataCalculo,
    required this.pontosUCalc,
    required this.pontosRetencao,
  });

  // Sobrescrevendo == e hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AreaData &&
        other.nome == nome &&
        other.tipoTerreno == tipoTerreno &&
        other.dataCalculo == dataCalculo;
  }

  @override
  int get hashCode => nome.hashCode ^ tipoTerreno.hashCode ^ dataCalculo.hashCode;
}
