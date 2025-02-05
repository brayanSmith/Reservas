import 'package:flutter/material.dart';
import '../viewmodels/time_selection_logic.dart';// Asegúrate de que esta ruta sea correcta.

class TimeSelectionPage extends StatefulWidget {
  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  final TimeSelectionLogic _logic = TimeSelectionLogic();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey para Scaffold

  @override
  void initState() {
    super.initState();
    _logic.initData(_onDataUpdated); // Inicializamos la lógica con el callback de actualización.
  }

  // Callback que actualiza la UI cada vez que los datos cambian
  void _onDataUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asignamos el GlobalKey al Scaffold
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: ClipPath(
          clipper: WaveClipper(), // Puedes usar tu propio Clipper si es necesario
          child: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.orange.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 10,
            title: Text(
              'Seleccionar Hora y Tipo de Reserva',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo para ingresar el nombre del usuario
                  Text(
                    'Ingrese su nombre:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10), // Espaciado entre widgets
                  TextField(
                    onChanged: _logic.onNombreChanged, // Llama a la función para actualizar el nombre
                    decoration: InputDecoration(
                      hintText: 'Ingrese su nombre', // Texto de sugerencia cuando el campo está vacío
                      labelText: 'Nombre', // Etiqueta del campo
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados para el campo de texto
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Selector de fecha con icono de calendario
                  Text(
                    'Seleccione una fecha:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _logic.selectDate(context), // Llama a la función para seleccionar la fecha
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Espaciado interno del contenedor
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Bordes grises
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _logic.selectedDate.isEmpty
                                ? 'Seleccione una fecha'
                                : _logic.selectedDate, // Muestra la fecha seleccionada
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Icon(
                            Icons.calendar_today, // Icono de calendario
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Selector de hora
                  Text(
                    'Seleccione una hora:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10),
                  // Si no hay horas disponibles, se muestra un mensaje de error
                  _logic.availableTimes.isEmpty
                      ? Text(
                          'Lo sentimos, no hay agenda disponible para el día seleccionado.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red), // Texto en rojo para resaltar el mensaje
                        )
                      : Wrap( // Usa Wrap para mostrar las horas disponibles
                          spacing: 10, // Espaciado entre las opciones
                          children: _logic.availableTimes.map((time) {
                            return ChoiceChip( // Usamos ChoiceChip para que el usuario seleccione una hora
                              label: Text(time),
                              selected: _logic.selectedTime == time, // Marca la hora seleccionada
                              onSelected: (isSelected) {
                                setState(() {
                                  _logic.selectedTime = isSelected ? time : ''; // Actualiza la hora seleccionada
                                });
                              },
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 20),

                  // Tipo de Reserva
                  Text(
                    'Tipo de Reserva:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: _logic.onTipoReservaChanged, // Actualiza el tipo de reserva cuando cambia el texto
                    decoration: InputDecoration(
                      hintText: 'Ingrese el tipo de reserva', // Texto sugerido
                      labelText: 'Tipo de Reserva', // Etiqueta del campo
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados para el campo de texto
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Si se ha ingresado un tipo de reserva, lo mostramos
                  if (_logic.tipoReserva.isNotEmpty)
                    Text(
                      'Tipo de reserva ingresado: ${_logic.tipoReserva}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 20),

                  // Muestra la fecha y hora seleccionada si ambos están disponibles
                  if (_logic.selectedTime.isNotEmpty &&
                      _logic.selectedDate.isNotEmpty)
                    Text(
                      'Fecha y hora seleccionada: ${_logic.selectedDate} ${_logic.selectedTime}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 20),

                  // Botón para confirmar la reserva
                  ElevatedButton(
                    onPressed: () => _logic.confirmarReserva(context), // Llama a la función para confirmar la reserva
                    child: Text('Confirmar Reserva'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados para el botón
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Clipper personalizado para crear el efecto de ola
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 10);
    path.quadraticBezierTo(3 * size.width / 4, size.height - 30, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
