import 'package:cloud_firestore/cloud_firestore.dart';

class AreaService {
  final CollectionReference _areaCollection =
      FirebaseFirestore.instance.collection('Area'); // Certifique-se que o nome da coleção está igual no Firestore

  /// Cria uma nova área no Firestore.
  Future<void> criarArea({
    required String nomeArea,
    required double entreLinha,
    required double entrePlantas,
    required String tipoTerreno,
  }) async {
    try {
      DocumentReference docRef = await _areaCollection.add({
        'nomeArea': nomeArea,
        'entreLinha': entreLinha.toStringAsFixed(2),
        'entrePlantas': entrePlantas.toStringAsFixed(2),
        'tipoTerreno': tipoTerreno,
        'valorTensiometro': "", // reservado para atualização futura
      });

      print("Área criada com sucesso. ID: ${docRef.id}");
    } catch (e) {
      print("Erro ao criar área: $e");
      rethrow;
    }
  }

  /// Lista todas as áreas do Firestore com seus respectivos IDs.
  Future<List<Map<String, dynamic>>> listarAreas() async {
    try {
      QuerySnapshot snapshot = await _areaCollection.get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Erro ao listar áreas: $e");
      return [];
    }
  }

  /// Atualiza uma área existente.
  Future<void> atualizarArea({
    required String id,
    String? nomeArea,
    double? entreLinha,
    double? entrePlantas,
    String? tipoTerreno,
    String? valorTensiometro,
  }) async {
    try {
      Map<String, dynamic> dadosAtualizados = {};

      if (nomeArea != null) dadosAtualizados['nomeArea'] = nomeArea;
      if (entreLinha != null) dadosAtualizados['entreLinha'] = entreLinha.toStringAsFixed(2);
      if (entrePlantas != null) dadosAtualizados['entrePlantas'] = entrePlantas.toStringAsFixed(2);
      if (tipoTerreno != null) dadosAtualizados['tipoTerreno'] = tipoTerreno;
      if (valorTensiometro != null) dadosAtualizados['valorTensiometro'] = valorTensiometro;

      if (dadosAtualizados.isNotEmpty) {
        await _areaCollection.doc(id).update(dadosAtualizados);
        print("Área atualizada com sucesso: $id");
      } else {
        print("Nenhum dado fornecido para atualização.");
      }
    } catch (e) {
      print("Erro ao atualizar área: $e");
      rethrow;
    }
  }

  /// Remove uma área do Firestore.
  Future<void> excluirArea(String id) async {
    try {
      await _areaCollection.doc(id).delete();
      print("Área excluída com sucesso: $id");
    } catch (e) {
      print("Erro ao excluir área: $e");
      rethrow;
    }
  }

  /// Busca uma área pelo ID.
  Future<Map<String, dynamic>?> buscarAreaPorId(String id) async {
    try {
      DocumentSnapshot doc = await _areaCollection.doc(id).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      } else {
        print("Área não encontrada: $id");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar área por ID: $e");
      return null;
    }
  }
}
