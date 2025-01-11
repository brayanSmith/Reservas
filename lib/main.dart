import 'package:flutter/material.dart';
import 'views/time_selection_page.dart'; // Importamos la página que creamos

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimeSelectionPage(), // Llamamos a la página aquí
    );
  }
}
