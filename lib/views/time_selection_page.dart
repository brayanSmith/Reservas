import 'package:flutter/material.dart';
import '../services/api_findReserva.dart'; // Asegúrate de tener este servicio
import '../services/api_addReserva.dart'; // Asegúrate de tener este servicio
import '../utils/time_utils.dart'; // Asegúrate de tener la función generarHorasDisponibles

class TimeSelectionPage extends StatefulWidget {
  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  List<String> availableTimes = [];
  String selectedTime = '';
  List<String> fechasReservadas = [];
  String selectedDate = '';
  String tipoReserva = '';
  String nombre = '';

  final ApiConsultarReservas _apiConsultarReservas = ApiConsultarReservas();
  final ApiCrearReserva _apiCrearReserva = ApiCrearReserva();

  @override
  void initState() {
    super.initState();
    selectedDate = _formatDate(DateTime.now());
    _loadFechas();
    _loadAvailableTimes(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _loadFechas() async {
    try {
      List<String> fechas = await _apiConsultarReservas.fetchAllFechas();
      setState(() {
        fechasReservadas = fechas;
      });
    } catch (e) {
      print('Error al cargar fechas: $e');
    }
  }

  void _loadAvailableTimes(DateTime date) {
    String horaEntrada = '08:00';
    String horaSalida = '18:00';
    int intervaloMinutos = 30;
    String inicioBreak = '12:00';
    String finBreak = '13:00';

    availableTimes = generarHorasDisponibles(
      intervaloMinutos,
      horaEntrada,
      horaSalida,
      _formatDate(date),
      fechasReservadas,
      inicioBreak,
      finBreak,
    )!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = _formatDate(pickedDate);
      });
      _loadAvailableTimes(pickedDate);
    }
  }

  void _onTipoReservaChanged(String value) {
    setState(() {
      tipoReserva = value;
    });
  }

  void _onNombreChanged(String value) {
    setState(() {
      nombre = value;
    });
  }

  String _formatDateTimeForJson(String date, String time) {
    List<String> parts = date.split('/');
    if (parts.length != 3) {
      throw FormatException("La fecha no tiene el formato correcto DD/MM/YYYY");
    }
    String formattedTime = '${time.padRight(5, '0')}:00';
    return '$date $formattedTime';
  }

  void _confirmarReserva() async {
    if (selectedDate.isNotEmpty &&
        selectedTime.isNotEmpty &&
        tipoReserva.isNotEmpty &&
        nombre.isNotEmpty) {
      try {
        String fechaHoraReserva = _formatDateTimeForJson(selectedDate, selectedTime);

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
                    Navigator.of(context).pop();
                    try {
                      bool success = await _apiCrearReserva.addReserva(
                        nombre: nombre,
                        fechaHoraReserva: fechaHoraReserva,
                        tipoReserva: tipoReserva,
                        duracion: 30,
                      );
                      if (success) {
                        setState(() {
                          nombre = '';
                          selectedDate = _formatDate(DateTime.now());
                          selectedTime = '';
                          tipoReserva = '';
                        });
                        _mostrarDialogoExito();
                      } else {
                        _mostrarError("No se pudo crear la reserva.");
                      }
                    } catch (e) {
                      print("Error al crear la reserva: $e");
                      _mostrarError("Error al crear la reserva.");
                    }
                  },
                  child: Text("Confirmar datos de reserva"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Modificar"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error al preparar la reserva: $e");
        _mostrarError("Error al preparar la reserva.");
      }
    } else {
      _mostrarError("Por favor, complete todos los campos.");
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
                Navigator.of(context).pop();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingrese su nombre:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextField(
                onChanged: _onNombreChanged,
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
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedDate.isEmpty ? 'Seleccione una fecha' : selectedDate,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Seleccione una hora:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              availableTimes.isEmpty
                  ? CircularProgressIndicator()
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
              TextField(
                onChanged: _onTipoReservaChanged,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese el tipo de reserva',
                  labelText: 'Tipo de Reserva',
                ),
              ),
              SizedBox(height: 20),
              if (tipoReserva.isNotEmpty)
                Text('Tipo de reserva ingresado: $tipoReserva', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              if (selectedTime.isNotEmpty && selectedDate.isNotEmpty)
                Text('Fecha y hora seleccionada: $selectedDate $selectedTime', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmarReserva,
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
