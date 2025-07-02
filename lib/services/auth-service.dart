import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


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
  Future<Map<String, dynamic>?> getPerfil() async {
  final prefs = await SharedPreferences.getInstance();
  final cpf = prefs.getString('cpf');

  if (cpf == null) return null;

  final snapshot = await _firestore
      .collection('pessoas')
      .where('cpf', isEqualTo: cpf)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;

  return snapshot.docs.first.data();
}
Future<bool> loginComGoogle(BuildContext context) async {
  try {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // força mostrar as contas
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return false;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);

      final snapshot = await _firestore
          .collection('pessoas')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      String docId;

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        docId = doc.id;
      } else {
        final novoDoc = await _firestore.collection('pessoas').add({
          'email': user.email,
          'nome': user.displayName?.split(' ').first ?? '',
          'sobrenome': user.displayName?.split(' ').skip(1).join(' ') ?? '',
          'fotoUrl': user.photoURL ?? '',
          'criadoEm': FieldValue.serverTimestamp(),
        });
        docId = novoDoc.id;
      }

      await prefs.setString('cpf', docId);

      final doc = await _firestore.collection('pessoas').doc(docId).get();
      final dados = doc.data();

      if (dados?['cpf'] == null || dados?['telefone'] == null) {
        Navigator.pushReplacementNamed(context, '/editar-perfil');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }

      return true;
    }

    return false;
  } catch (e) {
    debugPrint('Alexandre é gay: $e');
    return false;
  }
}

}