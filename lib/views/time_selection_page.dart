import 'package:flutter/material.dart';
import '../viewmodels/time_selection_logic.dart'; // Lógica de la página

class TimeSelectionPage extends StatefulWidget {
  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  final TimeSelectionLogic _logic = TimeSelectionLogic();

  @override
  void initState() {
    super.initState();
    _logic.initData(_onDataUpdated);
  }

  void _onDataUpdated() {
    setState(() {});
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
              // Campo para ingresar el nombre del usuario
              Text(
                'Ingrese su nombre:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: _logic.onNombreChanged,
                decoration: InputDecoration(
                  hintText: 'Ingrese su nombre',
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 20),

              // Selector de fecha
              Text(
                'Seleccione una fecha:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _logic.selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _logic.selectedDate.isEmpty
                        ? 'Seleccione una fecha'
                        : _logic.selectedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
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
              _logic.availableTimes.isEmpty
                  ? Text(
                      'Lo sentimos, no hay agenda disponible para el día seleccionado.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.red),
                    )
                  : Wrap(
                      spacing: 10,
                      children: _logic.availableTimes.map((time) {
                        return ChoiceChip(
                          label: Text(time),
                          selected: _logic.selectedTime == time,
                          onSelected: (isSelected) {
                            setState(() {
                              _logic.selectedTime = isSelected ? time : '';
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
                onChanged: _logic.onTipoReservaChanged,
                decoration: InputDecoration(
                  hintText: 'Ingrese el tipo de reserva',
                  labelText: 'Tipo de Reserva',
                ),
              ),
              SizedBox(height: 20),

              if (_logic.tipoReserva.isNotEmpty)
                Text(
                  'Tipo de reserva ingresado: ${_logic.tipoReserva}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              SizedBox(height: 20),

              if (_logic.selectedTime.isNotEmpty &&
                  _logic.selectedDate.isNotEmpty)
                Text(
                  'Fecha y hora seleccionada: ${_logic.selectedDate} ${_logic.selectedTime}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              SizedBox(height: 20),

              // Botón para confirmar la reserva
              ElevatedButton(
                onPressed: () => _logic.confirmarReserva(context),
                child: Text('Confirmar Reserva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
