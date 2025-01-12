import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_findReserva.dart'; // Asegúrate de tener este servicio
import '../services/api_addReserva.dart'; // Asegúrate de tener este servicio
import '../utils/time_utils.dart'; // Asegúrate de tener la función generarHorasDisponibles
import '../main.dart';

class TimeSelectionLogic {
  // Lista de horas disponibles para la reserva
  List<String> availableTimes = [];
  // Hora seleccionada por el usuario
  String selectedTime = '';
  // Lista de fechas ya reservadas
  List<String> fechasReservadas = [];
  // Fecha seleccionada por el usuario
  String selectedDate = '';
  // Tipo de reserva (puede ser algo como 'individual' o 'grupal')
  String tipoReserva = '';
  // Nombre del usuario que está realizando la reserva
  String nombre = '';

  // Instancia de las clases de servicio que realizan las consultas y creaciones de reserva
  final ApiConsultarReservas _apiConsultarReservas = ApiConsultarReservas();
  final ApiCrearReserva _apiCrearReserva = ApiCrearReserva();

  // Callback para actualizar la UI cuando los datos cambian
  Function()? onDataUpdated;

  // Inicializa los datos y establece la fecha inicial y carga las fechas reservadas
  void initData(Function() onDataUpdatedCallback) {
    onDataUpdated = onDataUpdatedCallback;
    selectedDate = _formatDate(DateTime.now()); // Asigna la fecha actual formateada
    _loadFechas(); // Carga las fechas reservadas
    _loadAvailableTimes(DateTime.now()); // Carga las horas disponibles para la fecha actual
  }

  // Formatea la fecha para mostrarla en formato DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Carga las fechas reservadas llamando a la API
  Future<void> _loadFechas() async {
    try {
      List<String> fechas = await _apiConsultarReservas.fetchAllFechas();
      fechasReservadas = fechas;
      _updateUI(); // Actualiza la UI cuando las fechas sean cargadas
    } catch (e) {
      print('Error al cargar fechas: $e');
    }
  }

  // Carga las horas disponibles para la fecha seleccionada
  void _loadAvailableTimes(DateTime date) {
    // Parámetros fijos de las horas de inicio y fin, y el intervalo
    String horaEntrada = '08:00';
    String horaSalida = '18:00';
    int intervaloMinutos = 30;
    String inicioBreak = '12:00';
    String finBreak = '13:00';

    // Llama a la función para generar las horas disponibles con los parámetros anteriores
    availableTimes = generarHorasDisponibles(
      intervaloMinutos,
      horaEntrada,
      horaSalida,
      _formatDate(date),
      fechasReservadas,
      inicioBreak,
      finBreak,
    )!;
    _updateUI(); // Actualiza la UI con las horas disponibles cargadas
  }

  // Abre el selector de fechas y actualiza la fecha seleccionada
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      selectedDate = _formatDate(pickedDate); // Formatea la fecha seleccionada
      _loadAvailableTimes(pickedDate); // Carga las horas disponibles para la nueva fecha seleccionada
      _updateUI(); // Actualiza la UI con la nueva fecha
    }
  }

  // Callback que se activa cuando el tipo de reserva cambia
  void onTipoReservaChanged(String value) {
    tipoReserva = value; // Actualiza el tipo de reserva
    _updateUI(); // Actualiza la UI
  }

  // Callback que se activa cuando el nombre cambia
  void onNombreChanged(String value) {
    nombre = value; // Actualiza el nombre del usuario
    _updateUI(); // Actualiza la UI
  }

  // Formatea la fecha y hora para enviarlo como un string en formato adecuado
  String _formatDateTimeForJson(String date, String time) {
    List<String> parts = date.split('/');
    if (parts.length != 3) {
      throw FormatException("La fecha no tiene el formato correcto DD/MM/YYYY");
    }
    String formattedTime = '${time.padRight(5, '0')}:00'; // Asegura que la hora tenga formato correcto
    return '$date $formattedTime'; // Combina la fecha y hora en un solo string
  }

  // Llama al servicio para confirmar la reserva
  void confirmarReserva(BuildContext context) async {
  if (selectedDate.isNotEmpty && selectedTime.isNotEmpty && tipoReserva.isNotEmpty && nombre.isNotEmpty) {
    try {
      // Formatea la fecha y hora para la reserva
      String fechaHoraReserva = _formatDateTimeForJson(selectedDate, selectedTime);

      // Imprime los datos en formato JSON para verificar
      Map<String, dynamic> reservaJson = {
        'nombre': nombre,
        'fechaHoraReserva': fechaHoraReserva,
        'tipoReserva': tipoReserva,
        'duracion': 30
      };

      print("Datos de reserva en formato JSON: ${reservaJson}");

      // Realiza la confirmación de la reserva llamando al servicio
      bool success = await _apiCrearReserva.addReserva(
        nombre: nombre,
        fechaHoraReserva: fechaHoraReserva,
        tipoReserva: tipoReserva,
        duracion: 30,
      );

      if (success) {
        // Almacenar los datos antes de limpiarlos
        String tempNombre = nombre;
        String tempFecha = selectedDate;
        String tempHora = selectedTime;
        String tempTipoReserva = tipoReserva;

        // Limpia los campos después de la reserva exitosa
        selectedDate = _formatDate(DateTime.now());
        selectedTime = '';
        tipoReserva = '';
        nombre = '';
        _updateUI();

        // Mostrar el diálogo de éxito y luego enviar los datos a WhatsApp
        _mostrarDialogoExito(context, tempNombre, tempFecha, tempHora, tempTipoReserva); 
      } else {
        _mostrarError(context, "No se pudo crear la reserva.");
      }
    } catch (e) {
      print("Error al crear la reserva: $e");
      _mostrarError(context, "Error al crear la reserva.");
    }
  } else {
    _mostrarError(context, "Por favor, complete todos los campos.");
  }
}

// Muestra un diálogo de éxito cuando la reserva se confirma correctamente
void _mostrarDialogoExito(BuildContext context, String nombre, String fecha, String hora, String tipoReserva) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Reserva Confirmada"),
        content: Text("Reserva creada exitosamente."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              _enviarDatosWhatsapp(nombre, fecha, hora, tipoReserva); // Redirige a WhatsApp con los datos correctos
              // Redirige al Main (o a la pantalla principal)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()), // Aquí usas tu widget principal (MainPage)
              );
            },
            child: Text("Abrir WhatsApp"),
          ),
        ],
      );
    },
  );
}



  // Muestra un diálogo de error si ocurre algún problema
  void _mostrarError(BuildContext context, String mensaje) {
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

// Función que abre WhatsApp con los datos de la reserva
void _enviarDatosWhatsapp(String nombre, String fecha, String hora, String tipoReserva) async {
  // Mensaje con los mismos datos utilizados en la API
  final String message = "Hola, quiero realizar una reserva:\n\n"
      "Nombre: $nombre\n"
      "Fecha: $fecha\n"
      "Hora: $hora\n"
      "Tipo de Reserva: $tipoReserva";

  // Formateo de la URL para WhatsApp
  final String whatsappUrl = "https://wa.me/573203867042?text=${Uri.encodeComponent(message)}";

  try {
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl); // Abre WhatsApp con los datos
    } else {
      throw 'No se pudo abrir WhatsApp';
    }
  } catch (e) {
    print('Error al intentar abrir WhatsApp: $e');
  }
}


  // Llama al callback para actualizar la UI cuando los datos cambian
  void _updateUI() {
    if (onDataUpdated != null) {
      onDataUpdated!(); // Llama al callback para actualizar la UI
    }
  }
}
