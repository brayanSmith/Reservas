import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCrearReserva {
  final String baseUrl = "https://www.appsheet.com/api/v2/apps";
  final String apiKey = "V2-cmV7J-30281-z5uKp-Dbey9-2m9H9-cBnPx-0Bzmt-Qzt2C";

  Future<bool> addReserva({
    required String nombre,
    required String fechaHoraReserva,
    required String tipoReserva,
    required int duracion,
  }) async {
    final url =
        "$baseUrl/4bfa319b-5a4a-4ca9-847d-7246fd5f0a41/tables/reservas/Action";

    final body = {
      "Action": "Add",
      "Properties": {
        "Locale": "es-ES",
        "Timezone": "UTC",
      },
      "Rows": [
        {
          "Nombre": nombre,
          "FechaHora_Reserva": fechaHoraReserva,
          "Tipo_Reserva": tipoReserva,
          "duracion": duracion,
        }
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": apiKey,
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error al agregar reserva: ${response.body}");
      return false;
    }
  }
}
