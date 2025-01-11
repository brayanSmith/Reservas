import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Asegúrate de importar tu servicio API
import 'utils/time_utils.dart'; // Asegúrate de importar la función generarHorasDisponibles
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimeSelectionPage(),
    );
  }
}

class TimeSelectionPage extends StatefulWidget {
  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  List<String> availableTimes = [];
  String selectedTime = '';
  List<String> fechasReservadas = []; // Aquí almacenaremos las fechas de la API
  String selectedDate = ''; // Variable para almacenar la fecha seleccionada
  String tipoReserva = ''; // Variable para almacenar el tipo de reserva
  String nombre = ''; // Variable para almacenar el nombre del usuario

  final ApiService _apiService = ApiService(); // Instancia de ApiService

  @override
  void initState() {
    super.initState();
    // Inicializamos selectedDate con la fecha actual
    selectedDate = _formatDate(DateTime.now()); // Formateamos la fecha actual en el formato adecuado

    // Llamamos a la API para obtener las fechas reservadas
    _loadFechas();

    // Generamos las horas disponibles para el día actual
    _loadAvailableTimes(DateTime.now());
  }

  // Método para obtener la fecha en formato MM/DD/YYYY
  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _loadFechas() async {
    try {
      // Esperamos la lista de fechas desde la API
      List<String> fechas = await _apiService.fetchAllFechas();

      setState(() {
        fechasReservadas = fechas;
      });
    } catch (e) {
      print('Error al cargar fechas: $e');
    }
  }

  // Método para cargar las horas disponibles para una fecha
  void _loadAvailableTimes(DateTime date) {
    String horaEntrada = '08:00';
    String horaSalida = '18:00';
    int intervaloMinutos = 30;
    String inicioBreak = '12:00';
    String finBreak = '13:00';

    // Llamamos a la función generarHorasDisponibles
    availableTimes = generarHorasDisponibles(
      intervaloMinutos,
      horaEntrada,
      horaSalida,
      _formatDate(date), // Usamos la fecha formateada
      fechasReservadas,
      inicioBreak,
      finBreak,
    )!;
  }

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = _formatDate(pickedDate); // Actualizamos la fecha seleccionada
      });

      // Una vez que se selecciona la fecha, generamos las horas disponibles
      _loadAvailableTimes(pickedDate);
    }
  }

  // Método para manejar el cambio del campo de texto "Tipo de Reserva"
  void _onTipoReservaChanged(String value) {
    setState(() {
      tipoReserva = value;
    });
  }

  // Método para manejar el cambio del campo de texto "Nombre"
  void _onNombreChanged(String value) {
    setState(() {
      nombre = value; // Actualiza el nombre ingresado por el usuario
    });
  }

  // Método para manejar la confirmación de la reserva
  void _confirmarReserva() {
    if (selectedDate.isNotEmpty && selectedTime.isNotEmpty && tipoReserva.isNotEmpty && nombre.isNotEmpty) {
      // Aquí puedes agregar la lógica para confirmar la reserva, por ejemplo, llamar a un servicio API
      // o mostrar un mensaje con los datos seleccionados

      // En este caso, solo mostramos un diálogo de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Reserva Confirmada"),
            content: Text(
                "Reserva Confirmada:\nNombre: $nombre\nFecha: $selectedDate\nHora: $selectedTime\nTipo: $tipoReserva"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } else {
      // Si faltan datos, mostramos un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Por favor, complete todos los campos antes de confirmar."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar Hora y Tipo de Reserva')),
      body: SingleChildScrollView( // Hacemos que el cuerpo sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingrese su nombre:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              // Campo de texto para el nombre del usuario
              TextField(
                onChanged: _onNombreChanged, // Actualiza el nombre cuando el texto cambie
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese su nombre',
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 20),
              Text('Seleccione una fecha:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context), // Llama al selector de fecha
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedDate.isEmpty
                        ? 'Seleccione una fecha'
                        : selectedDate,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Seleccione una hora:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              availableTimes.isEmpty
                  ? CircularProgressIndicator() // Cargando si no se ha obtenido la lista de horas
                  : Wrap(
                      spacing: 10,
                      children: availableTimes.map((time) {
                        return ChoiceChip(
                          label: Text(time),
                          selected: selectedTime == time,
                          onSelected: (isSelected) {
                            setState(() {
                              selectedTime = isSelected ? time : '';
                            });
                          },
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20),
              Text('Tipo de Reserva:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              // Campo de texto para el tipo de reserva
              TextField(
                onChanged: _onTipoReservaChanged, // Actualiza el tipo de reserva cuando el texto cambie
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese el tipo de reserva',
                  labelText: 'Tipo de Reserva',
                ),
                maxLines: 1, // Configura para que se vea como una línea (puedes poner un número mayor si quieres más líneas)
              ),
              SizedBox(height: 20),
              if (tipoReserva.isNotEmpty)
                Text('Tipo de reserva ingresado: $tipoReserva', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              if (selectedTime.isNotEmpty)
                Text('Hora seleccionada: $selectedTime', style: TextStyle(fontSize: 18)),

              // El botón para confirmar la reserva
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmarReserva, // Llama a la función de confirmación
                child: Text('Confirmar Reserva'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
