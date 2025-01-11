List<String>? generarHorasDisponibles(
  int intervaloMinutos,
  String horaEntrada,
  String horaSalida,
  String fechaReserva,
  List<String> fechasReservadas,
  String inicioBreak,
  String finBreak,
) {
  /// Función para convertir fecha de DD/MM/YYYY a MM/DD/YYYY
  String convertDateToUSFormat(String date) {
    List<String> parts = date.split('/');
    return "${parts[1]}/${parts[0]}/${parts[2]}";
  }

  /// Convertir la fecha de reserva al formato MM/DD/YYYY
  String fechaReservaUS = convertDateToUSFormat(fechaReserva);

  /// MODIFY CODE ONLY BELOW THIS LINE

  // Convertir una hora en formato "HH:MM" a minutos desde medianoche
  int timeToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  // Generar todos los intervalos de tiempo desde la hora de entrada hasta la hora de salida
  List<String> generateTimeIntervals(
      String horaEntrada, String horaSalida, int intervaloMinutos) {
    List<String> allTimes = [];

    // Convertimos las horas de entrada y salida a minutos desde medianoche
    int startTime = timeToMinutes(horaEntrada);
    int endTime = timeToMinutes(horaSalida);

    // Bucle para generar los intervalos de tiempo
    for (int minutes = startTime;
        minutes <= endTime;
        minutes += intervaloMinutos) {
      int hour = minutes ~/ 60; // Calcula la hora
      int minute = minutes % 60; // Calcula los minutos

      // Formateamos la hora y minuto en "HH:MM"
      String formattedHour = hour.toString().padLeft(2, '0');
      String formattedMinute = minute.toString().padLeft(2, '0');

      // Añadimos la hora al listado de tiempos
      allTimes.add("$formattedHour:$formattedMinute");
    }

    return allTimes;
  }

  // Filtrar las horas reservadas de acuerdo a la fecha de reserva
  List<String> filterReservedHours(List<String> allTimes, String fechaReservaUS,
      List<String> reservedDatesTimes) {
    List<String> availableTimes = [];

    for (String time in allTimes) {
      String fullDateTime = "$fechaReservaUS $time";

      // Ignorar segundos al comparar
      String formattedDateTime = fullDateTime + ":00"; // Agregar segundos
      if (!reservedDatesTimes.contains(formattedDateTime)) {
        availableTimes.add(time); // Solo agregamos horas no reservadas
      }
    }
    return availableTimes;
  }

  // Filtrar las horas dentro del rango de break
  List<String> filterBreakHours(
      List<String> availableTimes, String inicioBreak, String finBreak) {
    List<String> filteredTimes = [];

    int breakStartTime = timeToMinutes(inicioBreak);
    int breakEndTime = timeToMinutes(finBreak);

    for (String time in availableTimes) {
      int currentTime = timeToMinutes(time);
      if (currentTime < breakStartTime || currentTime >= breakEndTime) {
        filteredTimes.add(time); // Solo agregar tiempos fuera del break
      }
    }

    return filteredTimes;
  }

  // Filtramos solo las fechas y horas completas "MM/DD/YYYY HH:MM"
  List<String> reservedDatesTimes = fechasReservadas;

  // Generamos los intervalos de tiempo desde la hora de entrada hasta la hora de salida
  List<String> allTimes =
      generateTimeIntervals(horaEntrada, horaSalida, intervaloMinutos);

  // Filtramos las horas reservadas para la fecha de reserva
  List<String> availableTimes =
      filterReservedHours(allTimes, fechaReservaUS, reservedDatesTimes);

  // Filtramos las horas dentro del break
  availableTimes = filterBreakHours(availableTimes, inicioBreak, finBreak);

  // Retornamos la lista de horas disponibles
  return availableTimes;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}

/*void main() {
  List<String>? horasDisponibles = generarHorasDisponibles(
    30, // Intervalo de 30 minutos
    "09:00", // Hora de entrada
    "17:00", // Hora de salida
    "11/01/2025", // Fecha de reserva en formato DD/MM/YYYY
    ["01/11/2025 09:30:00", "01/11/2025 16:00:00"], // Reservas
    "12:00", // Inicio del descanso
    "13:00", // Fin del descanso
  );

  print(horasDisponibles);
}*/
