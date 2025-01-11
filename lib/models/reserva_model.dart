class Reserva {
  final String fechaHoraReserva;

  Reserva({required this.fechaHoraReserva});

  // Método de fábrica para crear una instancia a partir de un Map
  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      fechaHoraReserva: map['FechaHora_Reserva'] ?? '', // Extrae el campo FechaHora_Reserva
    );
  }
}
