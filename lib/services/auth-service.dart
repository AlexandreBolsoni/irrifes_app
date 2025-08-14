import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===========================
  // LOGIN COM GOOGLE
  // ===========================

  Future<bool> loginComGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final auth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(cred);
      final user = userCred.user;
      if (user == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);

      final snap = await _firestore
          .collection('pessoas')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        final doc = snap.docs.first;
        final data = doc.data();
        final cpf = data['cpf'] as String?;

        await prefs.setString('cpf', cpf ?? '');
        await prefs.setString('perfilDocId', doc.id);
        await prefs.setBool('perfilIncompleto', cpf == null || cpf.isEmpty);
      } else {
        final novoDoc = await _firestore.collection('pessoas').add({
          'email': user.email,
          'nome': user.displayName ?? '',
          'fotoUrl': user.photoURL ?? '',
          'criadoEm': FieldValue.serverTimestamp(),
        });

        await prefs.setBool('perfilIncompleto', true);
        await prefs.setString('cpf', '');
        await prefs.setString('perfilDocId', novoDoc.id);
      }

      return true;
    } catch (e) {
      debugPrint('Erro no login com Google: $e');
      return false;
    }
  }

  // ===========================
  // SAIR
  // ===========================

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
  }

  // ===========================
  // PERFIL & SESSÃO
  // ===========================

  Future<bool> estaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logado') ?? false;
  }

  Future<String?> cpfSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cpf');
  }

  Future<Map<String, dynamic>?> getPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docId = prefs.getString('perfilDocId');
      Map<String, dynamic> perfil = {};

      if (docId != null && docId.isNotEmpty) {
        final snap = await _firestore.collection('pessoas').doc(docId).get();
        if (snap.exists) perfil = snap.data()!;
      } else {
        final cpf = prefs.getString('cpf');
        if (cpf != null && cpf.isNotEmpty) {
          final snap = await _firestore
              .collection('pessoas')
              .where('cpf', isEqualTo: cpf)
              .limit(1)
              .get();
          if (snap.docs.isNotEmpty) perfil = snap.docs.first.data();
        }
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return perfil.isEmpty ? null : perfil;

      final metodo = user.providerData.any((p) => p.providerId == 'google.com')
          ? 'Login com Google'
          : 'Outro método';

      return {
        ...perfil,
        'email': user.email ?? '',
        'lastSignInTime':
            user.metadata.lastSignInTime?.toIso8601String() ?? '',
        'lastSignInMethod': metodo,
      };
    } catch (e) {
      debugPrint('Erro ao buscar perfil: $e');
      return null;
    }
  }
    // ===========================
  // ATUALIZAR PERFIL
  // ===========================
  Future<bool> atualizarPerfil(Map<String, dynamic> dados, String resultado) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docId = prefs.getString('perfilDocId');

      if (docId == null || docId.isEmpty) {
        debugPrint('Nenhum perfilDocId salvo para atualização');
        return false;
      }

      // Atualiza documento no Firestore
      await _firestore.collection('pessoas').doc(docId).update(dados);

      // Se o CPF foi alterado, salvar também no SharedPreferences
      if (dados.containsKey('cpf')) {
        await prefs.setString('cpf', dados['cpf'] ?? '');
        await prefs.setBool(
            'perfilIncompleto', (dados['cpf'] ?? '').isEmpty);
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar perfil: $e');
      return false;
    }
  }

  // ===========================
  // EXCLUIR CONTA
  // ===========================
  Future<bool> excluirConta() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('Nenhum usuário logado para excluir conta');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final docId = prefs.getString('perfilDocId');

      // Excluir documento do Firestore
      if (docId != null && docId.isNotEmpty) {
        await _firestore.collection('pessoas').doc(docId).delete();
      }

      // Excluir usuário do FirebaseAuth
      await user.delete();

      // Limpar SharedPreferences
      await prefs.clear();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint(
            'Usuário precisa fazer login novamente para excluir conta');
      }
      debugPrint('Erro FirebaseAuth ao excluir conta: $e');
      return false;
    } catch (e) {
      debugPrint('Erro ao excluir conta: $e');
      return false;
    }
  }

}
