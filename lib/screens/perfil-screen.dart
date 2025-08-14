import 'package:flutter/material.dart';
import '../widgets/bottom-nav.dart';
import '../services/auth-service.dart';

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

  Future<void> _editarCampo(String campo, String label, String valorAtual) async {
    final controller = TextEditingController(text: valorAtual);
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $label"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Salvar")),
        ],
      ),
    );

    if (resultado != null && resultado.isNotEmpty) {
    await _authService.atualizarPerfil({campo: resultado}, campo);
      _carregarPerfil();
    }
  }

  Future<void> _logout() async {
    await _authService.sair();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> _excluirConta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir conta"),
        content: const Text(
          "Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _authService.excluirConta();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
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

  Widget _campoPerfil(String titulo, String valor, String campo,
      {bool podeEditar = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.green)),
              Text(valor.isEmpty ? 'Não informado' : valor),
            ],
          ),
        ),
        if (podeEditar)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () => _editarCampo(campo, titulo, valor),
          ),
      ],
    );
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
                        )
                      : const Icon(Icons.account_circle,
                          size: 100, color: Colors.white),
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
                    : Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _campoPerfil("NOME", _perfil!['nome'] ?? '', 'nome'),
                              const Divider(),
                              _campoPerfil("SOBRENOME",
                                  _perfil!['sobrenome'] ?? '', 'sobrenome'),
                              const Divider(),
                              _campoPerfil(
                                  "CPF", formatarCpf(_perfil!['cpf'] ?? ''), 'cpf'),
                              const Divider(),
                              _campoPerfil("TELEFONE",
                                  formatarTelefone(_perfil!['telefone'] ?? ''),
                                  'telefone'),
                              const Divider(),
                              // EMAIL SEM EDIÇÃO
                              _campoPerfil("EMAIL", _perfil!['email'] ?? '', 'email',
                                  podeEditar: false),
                              const Divider(),
                              const Text('ÚLTIMO LOGIN',
                                  style: TextStyle(color: Colors.green)),
                              Text(
                                (_perfil!['lastSignInTime'] ?? '').isNotEmpty
                                    ? DateTime.parse(
                                            _perfil!['lastSignInTime'])
                                        .toLocal()
                                        .toString()
                                    : 'Não disponível',
                              ),
                              const Divider(),
                              const Text('MÉTODO DE LOGIN',
                                  style: TextStyle(color: Colors.green)),
                              Text(_perfil!['lastSignInMethod'] ?? 'Desconhecido'),
                            ],
                          ),
                        ),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: _excluirConta,
              child: const Text('EXCLUIR CONTA'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
