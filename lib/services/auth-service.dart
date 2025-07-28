import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================================
  // LOGIN & AUTENTICAÇÃO
  // ================================

Future<bool> entrar({
  String? email,
  String? cpf,
  required String senha,
  bool manterLogado = false,
}) async {
  try {
    String? loginEmail = email;

    if (loginEmail == null && cpf != null) {
      final query = await _firestore
          .collection('pessoas')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return false;

      final data = query.docs.first.data();
      loginEmail = data['email'];
      if (loginEmail == null || loginEmail.isEmpty) return false;
    }

    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: loginEmail!,
      password: senha,
    );

    final user = cred.user;
    if (user == null) return false;

    final snap = await _firestore
        .collection('pessoas')
        .where('email', isEqualTo: loginEmail)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return false;

    final doc = snap.docs.first;
    final data = doc.data();
    final cpfSalvo = data['cpf'] ?? '';

    if (manterLogado) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);
      await prefs.setString('cpf', cpfSalvo);
      await prefs.setString('perfilDocId', doc.id);
      await prefs.setBool('perfilIncompleto', cpfSalvo.isEmpty);
    }

    return true;
  } catch (e) {
    debugPrint('Erro no login com email/cpf: $e');
    return false;
  }
}

  /// Login com Google
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

  /// Sair do sistema (logout)
  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
  }

  // ================================
  // CADASTRO
  // ================================

  /// Cadastro usando e-mail e senha
  Future<bool> cadastrarComEmail({
    required BuildContext context,
    required String email,
    required String senha,
    required String nome,
    required String sobrenome,
    required String cpf,
    required String telefone,
  }) async {
    try {
      final docRef = await _firestore.collection('pessoas').add({
        'email': email,
        'nome': nome,
        'sobrenome': sobrenome,
        'cpf': cpf,
        'telefone': telefone,
        'senha': senha,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);
      await prefs.setString('cpf', cpf);
      await prefs.setString('perfilDocId', docRef.id);
      await prefs.setBool('perfilIncompleto', false);

      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro ao cadastrar usuário')),
      );
      return false;
    } catch (e) {
      debugPrint('Erro inesperado no cadastro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado no cadastro')),
      );
      return false;
    }
  }

  // ================================
  // PERFIL & SESSÃO
  // ================================

  /// Verifica se usuário está logado localmente
  Future<bool> estaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logado') ?? false;
  }

  /// Retorna o CPF salvo localmente
  Future<String?> cpfSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cpf');
  }

  /// Busca perfil completo (Firestore + FirebaseAuth)
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
          : user.providerData.any((p) => p.providerId == 'password')
              ? 'Login com e-mail'
              : 'Outro método';

      return {
        ...perfil,
        'email': user.email ?? '',
        'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String() ?? '',
        'lastSignInMethod': metodo,
      };
    } catch (e) {
      debugPrint('Erro ao buscar perfil: $e');
      return null;
    }
  }

  // ================================
  // RECUPERAÇÃO DE SENHA
  // ================================

  /// Busca e-mail pelo CPF
  Future<String?> buscarEmailPorCPF(String cpf) async {
    try {
      final query = await _firestore
          .collection('pessoas')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        debugPrint('Nenhum documento encontrado para CPF: $cpf');
        return null;
      }
      return query.docs.first.data()['email'] as String?;
    } catch (e) {
      debugPrint('Erro ao buscar e-mail por CPF: $e');
      return null;
    }
  }

  /// Verifica método de login (google, email ou outro)
  Future<String?> verificarMetodoLogin(String email) async {
    try {
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('google.com')) return 'google';
      if (methods.contains('password')) return 'email';
      return 'outro';
    } catch (e) {
      debugPrint('Erro ao verificar método de login: $e');
      return null;
    }
  }

  /// Envia código para e-mail (salva código no Firestore)
  Future<bool> enviarCodigoParaEmail(String email) async {
    try {
      final codigo = (Random().nextInt(900000) + 100000).toString();
      await _firestore.collection('codigos').doc(email).set({
        'codigo': codigo,
        'criadoEm': FieldValue.serverTimestamp(),
      });
      debugPrint('Código enviado para $email: $codigo');
      return true;
    } catch (e) {
      debugPrint('Erro ao enviar código: $e');
      return false;
    }
  }

  /// Verifica se o código digitado bate com o salvo
  Future<bool> verificarCodigoEmail(String email, String codigoDigitado) async {
    try {
      final doc = await _firestore.collection('codigos').doc(email).get();
      if (!doc.exists) return false;
      final codigo = doc.data()?['codigo'];
      return codigoDigitado == codigo;
    } catch (e) {
      debugPrint('Erro ao verificar código: $e');
      return false;
    }
  }

  /// Redefine senha e faz login automaticamente
  Future<bool> redefinirSenhaEFazerLogin(
      String email, String novaSenha, String cpf) async {
    try {
      final query = await _firestore
          .collection('pessoas')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return false;

      final doc = query.docs.first;
      final dados = doc.data();
      final senhaAntiga = dados['senha'];

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senhaAntiga,
      );

      await cred.user!.updatePassword(novaSenha);

      await _firestore.collection('pessoas').doc(doc.id).update({
        'senha': novaSenha,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logado', true);
      await prefs.setString('cpf', cpf);
      await prefs.setString('perfilDocId', doc.id);

      return true;
    } catch (e) {
      debugPrint('Erro ao redefinir senha e logar: $e');
      return false;
    }
  }

  Future<String> iniciarRecuperacaoSenhaPorCPF(String cpf) async {
    try {
      final email = await buscarEmailPorCPF(cpf);
      if (email == null) return 'email_nao_encontrado';

      final metodo = await verificarMetodoLogin(email);
      if (metodo != 'email') return 'metodo_invalido';

      final enviado = await enviarCodigoParaEmail(email);
      if (enviado) return 'codigo_enviado';

      return 'erro';
    } catch (e) {
      debugPrint('Erro iniciarRecuperacaoSenhaPorCPF: $e');
      return 'erro';
    }
  }
}
