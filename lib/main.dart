import 'package:flutter/material.dart';
import 'services/api_findReserva.dart'; // Asegúrate de importar tu servicio API
import 'services/api_addReserva.dart';
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

  final ApiConsultarReservas _apiConsultarReservas = ApiConsultarReservas(); // Instancia de ApiConsultarReservas
  final ApiCrearReserva _apiCrearReserva = ApiCrearReserva();


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
    //return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  

  Future<void> _loadFechas() async {
    try {
      // Esperamos la lista de fechas desde la API
      List<String> fechas = await _apiConsultarReservas.fetchAllFechas();

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




// Método para combinar la fecha y hora seleccionadas en el formato DD/MM/YYYY HH:MM:SS
String _formatDateTimeForJson(String date, String time) {
  // Validamos que la fecha esté en formato DD/MM/YYYY antes de usarla
  List<String> parts = date.split('/');
  if (parts.length != 3) {
    throw FormatException("La fecha no tiene el formato correcto DD/MM/YYYY");
  }

  // Agregamos los segundos al tiempo
  String formattedTime = '${time.padRight(5, '0')}:00';
  return '$date $formattedTime';
}

void _confirmarReserva() async {
  if (selectedDate.isNotEmpty &&
      selectedTime.isNotEmpty &&
      tipoReserva.isNotEmpty &&
      nombre.isNotEmpty) {
    try {
      // Construimos la fecha y hora en el formato requerido
      String fechaHoraReserva = _formatDateTimeForJson(selectedDate, selectedTime);

      // Mostrar diálogo con botones de Confirmar y Modificar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmar Reserva"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Detalles de la reserva:"),
                SizedBox(height: 10),
                Text("Nombre: $nombre"),
                Text("Fecha: $selectedDate"),
                Text("Hora: $selectedTime"),
                Text("Tipo: $tipoReserva"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Cerrar el diálogo

                  try {
                    // Llamamos a la API para crear la reserva
                    bool success = await _apiCrearReserva.addReserva(
                      nombre: nombre,
                      fechaHoraReserva: fechaHoraReserva,
                      tipoReserva: tipoReserva,
                      duracion: 30, // Duración fija de 30 minutos
                    );

                    if (success) {
                      // Reiniciar los campos después de confirmar la reserva
                      setState(() {
                        nombre = '';
                        selectedDate = _formatDate(DateTime.now());
                        selectedTime = '';
                        tipoReserva = '';
                      });

                      // Mostrar mensaje de éxito
                      _mostrarDialogoExito();
                    } else {
                      _mostrarError("No se pudo crear la reserva. Inténtelo nuevamente.");
                    }
                  } catch (e) {
                    print("Error al crear la reserva: $e");
                    _mostrarError("Ocurrió un error al crear la reserva. Inténtelo nuevamente.");
                  }
                },
                child: Text("Confirmar datos de reserva"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo y permitir la modificación
                },
                child: Text("Modificar"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error al preparar la reserva: $e");
      _mostrarError("Ocurrió un error al preparar la reserva. Inténtelo nuevamente.");
    }
  } else {
    _mostrarError("Por favor, complete todos los campos antes de confirmar.");
  }
}


void _mostrarDialogoExito() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Reserva Confirmada"),
        content: Text("Reserva creada exitosamente."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: Text("Cerrar"),
          ),
        ],
      );
    },
  );
}



void _mostrarError(String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
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
              if (selectedTime.isNotEmpty && selectedDate.isNotEmpty)
              Text('Fecha y hora seleccionada: $selectedDate $selectedTime', style: TextStyle(fontSize: 18)),


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
