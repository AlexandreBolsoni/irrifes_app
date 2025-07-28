import 'package:cloud_firestore/cloud_firestore.dart';

class AreaService {
  final CollectionReference _areaCollection =
      FirebaseFirestore.instance.collection('Area');

  /// Cria uma nova área no Firestore.
  Future<void> criarArea({
    required String nomeArea,
    required double entreLinha,
    required double entrePlantas,
    required String tipoTerreno,
  }) async {
    await _areaCollection.add({
      'nomeArea': nomeArea,
      'entreLinha': entreLinha.toStringAsFixed(2),
      'entrePlantas': entrePlantas.toStringAsFixed(2),
      'tipoTerreno': tipoTerreno,
      'valorTensiometro': "", // será adicionado depois
    });
  }

  /// Retorna todas as áreas com seus IDs.
  Future<List<Map<String, dynamic>>> listarAreas() async {
    QuerySnapshot snapshot = await _areaCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  /// Atualiza uma área existente pelo ID.
  Future<void> atualizarArea({
    required String id,
    String? nomeArea,
    double? entreLinha,
    double? entrePlantas,
    String? tipoTerreno,
    String? valorTensiometro,
  }) async {
    Map<String, dynamic> dadosAtualizados = {};
    if (nomeArea != null) dadosAtualizados['nomeArea'] = nomeArea;
    if (entreLinha != null) dadosAtualizados['entreLinha'] = entreLinha.toStringAsFixed(2);
    if (entrePlantas != null) dadosAtualizados['entrePlantas'] = entrePlantas.toStringAsFixed(2);
    if (tipoTerreno != null) dadosAtualizados['tipoTerreno'] = tipoTerreno;
    if (valorTensiometro != null) dadosAtualizados['valorTensiometro'] = valorTensiometro;

    await _areaCollection.doc(id).update(dadosAtualizados);
  }

  /// Remove uma área do Firestore.
  Future<void> excluirArea(String id) async {
    await _areaCollection.doc(id).delete();
  }

  /// Busca os dados de uma área pelo ID.
  Future<Map<String, dynamic>?> buscarAreaPorId(String id) async {
    DocumentSnapshot doc = await _areaCollection.doc(id).get();
    if (doc.exists) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }
    return null;
  }
}
