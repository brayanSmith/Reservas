import 'package:flutter/material.dart';
import 'time_selection_page.dart'; // Importa la vista de selección de hora

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo curvado
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5, // Altura del fondo curvado
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.amber.shade700,
                    Colors.amber.shade400,
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),

                  // Título de bienvenida
                  Text(
                    '¡Bienvenido a Barbería Elite!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Subtítulo descriptivo
                  Text(
                    'Reserva tu cita con estilo y vive una experiencia premium en cortes y cuidado personal.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade900,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),

                  // Imagen circular del logo
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber.shade700,
                        width: 4,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/barber_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Botón de navegación con transición scroll hacia abajo
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return TimeSelectionPage(); // La página a la que navegamos
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            // Animación de scroll hacia abajo
                            var begin = Offset(0.0, 1.0); // Comienza desde abajo
                            var end = Offset.zero; // El final es la posición normal
                            var curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            // Aplicamos el desplazamiento de scroll
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text('Hacer Reservación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Fondo negro
                      foregroundColor: Colors.amber.shade700, // Texto dorado
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 5, // Sombra para un efecto elegante
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes suaves
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Frase adicional
                  Text(
                    'Estilo y cuidado en un solo lugar.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ClipPath personalizado para el fondo curvado
class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8); // Línea hasta el 80% de la altura

    path.quadraticBezierTo(
      size.width * 0.5, size.height, // Punto de control (curvatura)
      size.width, size.height * 0.8, // Punto final de la curva
    );

    path.lineTo(size.width, 0); // Línea recta al tope derecho
    path.close(); // Cierra la figura
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No es necesario volver a recortar
  }
}
