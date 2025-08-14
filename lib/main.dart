import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:irrifes_app/screens/calcular.dart';
import 'package:irrifes_app/screens/perfil-screen.dart';
import 'screens/login-screen.dart';
import 'screens/home-screen.dart';
import 'screens/area-screen.dart';



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
        '/': (context) => LoginScreen(), // rota raiz para logi
        '/home': (context) => HomeScreen(),
        '/area': (context) => MinhasAreasScreen(),
        '/calcular': (context) => CalcularScreen(),
        '/perfil': (context) => PerfilScreen(),
      },
    );
  }
}
