class CitasReservadas {
  final String fechaHoraReserva;

  CitasReservadas({required this.fechaHoraReserva});

  // Método de fábrica para crear una instancia a partir de un Map
  factory CitasReservadas.fromMap(Map<String, dynamic> map) {
    return CitasReservadas(
      fechaHoraReserva: map['FechaHora_Reserva'] ?? '', // Extrae el campo FechaHora_Reserva
    );
  }
}
