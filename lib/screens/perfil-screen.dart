import 'package:flutter/material.dart';
import '../widgets/bottom-nav.dart';
import '../services/auth-service.dart';

import 'editar-perfil.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _currentIndex = 2;
  final AuthService _authService = AuthService();

  Map<String, dynamic>? _perfil;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final perfil = await _authService.getPerfil();
    setState(() {
      _perfil = perfil;
      _carregando = false;
    });
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/calcular');
        break;
      case 2:
        break;
    }
  }

  Future<void> _logout() async {
    await _authService.sair();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  String formatarCpf(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String formatarTelefone(String telefone) {
    if (telefone.length == 11) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7)}';
    } else if (telefone.length == 10) {
      return '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6)}';
    }
    return telefone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF2CAC50),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF2CAC50),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  (_perfil != null && (_perfil!['fotoUrl'] ?? '').isNotEmpty)
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_perfil!['fotoUrl']),
                          backgroundColor: Colors.transparent,
                        )
                      : const Icon(Icons.account_circle, size: 100, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'MEUS DADOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _carregando
                ? const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _perfil == null
                    ? const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'Não foi possível carregar os dados do perfil.',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("NOME", style: TextStyle(color: Colors.green)),
                            Text(_perfil!['nome'] ?? 'Sem nome'),
                            const Divider(),
                            const Text(
                              "SOBRENOME",
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(_perfil!['sobrenome'] ?? 'Sem sobrenome'),
                            const Divider(),
                            const Text("CPF", style: TextStyle(color: Colors.green)),
                            Text(formatarCpf(_perfil!['cpf'] ?? '')),
                            const Divider(),
                            const Text(
                              "TELEFONE",
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(formatarTelefone(_perfil!['telefone'] ?? '')),
                            const Divider(),
                          ],
                        ),
                      ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2CAC50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/editar-perfil');
              },
              child: const Text('EDITAR'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: _logout,
              child: const Text('SAIR'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
