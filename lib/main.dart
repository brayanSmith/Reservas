import 'package:flutter/material.dart';
import 'themes/theme.dart'; // Importa el archivo con el tema
import 'views/home_page.dart'; // Importa la vista de bienvenida

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de Barbería',
      theme: appTheme(), // Usa el tema desde el archivo externo
      home: HomePage(), // Define la vista inicial
    );
  }
}
