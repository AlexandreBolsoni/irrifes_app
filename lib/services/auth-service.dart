import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> entrar({
    required String cpf,
    required String senha,
    bool manterLogado = false,
  }) async {
    final snapshot = await _firestore
        .collection('pessoas')
        .where('cpf', isEqualTo: cpf)
        .where('senha', isEqualTo: senha)
        .limit(1)
        .get();

    final sucesso = snapshot.docs.isNotEmpty;

    if (sucesso && manterLogado) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);
      await prefs.setString('cpf', cpf);
    }

    return sucesso;
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void cadastrar(BuildContext context) {
    Navigator.pushNamed(context, '/cadastro');
  }

  void recuperarSenha(BuildContext context) {
    Navigator.pushNamed(context, '/refazer-senha');
  }

  Future<bool> estaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logado') ?? false;
  }

  Future<String?> cpfSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cpf');
  }
}
