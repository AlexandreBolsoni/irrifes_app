import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:irrifes_app/screens/calcular.dart';
import 'package:irrifes_app/screens/perfil-screen.dart';
import 'screens/login-screen.dart';
import 'screens/cadastro-screen.dart';
import 'screens/home-screen.dart';
import 'screens/editar-perfil.dart';
import 'screens/refazer-senha-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seu App',
      theme: ThemeData(fontFamily: 'Questrial'),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // rota raiz para login
        '/cadastro': (context) => CadastroScreen(),
        '/home': (context) => HomeScreen(),
        '/calcular': (context) => CalcularScreen(),
        '/editar-perfil': (context) => EditarPerfilScreen(),
        '/refazer-senha': (context) => RefazerSenhaScreen(),
        '/perfil': (context) => PerfilScreen(),
      },
    );
  }
}
