import 'package:flutter/material.dart';

// Función que define y devuelve el tema global de la aplicación
ThemeData appTheme() {
  return ThemeData(
    // Color primario de la aplicación
    primaryColor: Colors.black, // Negro como color principal

    // Paleta de colores global utilizando `ColorScheme`
    colorScheme: ColorScheme.light(
      primary: Colors.black, // Color principal (ej: AppBar, botones)
      secondary: Colors.amber.shade700, // Color secundario/acento (dorado elegante)
    ),

    // Color de fondo predeterminado para pantallas (scaffold)
    scaffoldBackgroundColor: Colors.white, // Fondo blanco para pantallas

    // Definición de la tipografía global
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.black87, // Texto principal en negro suave
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black87, // Texto secundario en negro suave
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.amber.shade700, // Títulos grandes en dorado
      ),
    ),

    // Estilo global para botones elevados (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Fondo negro para botones
        foregroundColor: Colors.amber.shade700, // Texto en dorado
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Espaciado dentro del botón
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // Texto en negrita para elegancia
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordes ligeramente redondeados
        ),
      ),
    ),

    // Estilo global para campos de texto (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Campo relleno con color
      fillColor: const Color.fromARGB(255, 255, 255, 255), // Color de fondo gris claro para campos de texto
      hintStyle: TextStyle(
        color: Colors.grey.shade500, // Hint text en gris claro
        fontSize: 16, // Tamaño de fuente para el hint text
      ),
      // Estilo del borde predeterminado
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados con radio de 20
        borderSide: BorderSide(color: Colors.amber.shade700), // Borde dorado
      ),
      // Estilo del borde cuando el campo está habilitado pero no enfocado
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        borderSide: BorderSide(color: Colors.grey), // Borde gris claro
      ),
      // Estilo del borde cuando el campo está enfocado
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        borderSide: BorderSide(color: Colors.amber.shade700), // Borde dorado
      ),
    ),

    // Estilo global para AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black, // Fondo negro del AppBar
      titleTextStyle: TextStyle(
        color: Colors.amber.shade700, // Texto del título en dorado
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ), // Estilo del título del AppBar
      iconTheme: IconThemeData(
        color: Colors.amber.shade700, // Iconos del AppBar en dorado
      ),
    ),

    // Estilo global para tarjetas (Cards)
    cardTheme: CardTheme(
      color: Colors.white, // Fondo blanco para tarjetas
      shadowColor: Colors.black54, // Sombras suaves en negro
      elevation: 4, // Altura de la sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
    ),
  );
}
