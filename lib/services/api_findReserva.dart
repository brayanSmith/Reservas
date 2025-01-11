import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reserva_model.dart';

class ApiConsultarReservas {
  final String url =
      'https://www.appsheet.com/api/v2/apps/4bfa319b-5a4a-4ca9-847d-7246fd5f0a41/tables/reservas/Action';

  final Map<String, String> headers = {
    'ApplicationAccessKey': 'V2-cmV7J-30281-z5uKp-Dbey9-2m9H9-cBnPx-0Bzmt-Qzt2C',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {
    "Action": "Find",
    "Properties": {
      "Locale": "en-US",
      "Timezone": "UTC",
    },
    "Rows": [],
  };

  // Método para obtener una lista de fechas y horas de reserva
  Future<List<String>> fetchAllFechas() async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

    print('Código de estado: ${response.statusCode}'); // Muestra el código de estado de la respuesta
    print('Respuesta completa: ${response.body}'); // Muestra el cuerpo completo de la respuesta

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        print('Respuesta decodificada: $responseBody'); // Muestra la respuesta decodificada

        // Extraer FechaHora_Reserva usando el modelo
        List<String> fechas = responseBody
            .map<String>((item) => Reserva.fromMap(item).fechaHoraReserva)
            .where((fecha) => fecha.isNotEmpty)
            .toList();
            print('Fechas extraídas: $fechas'); // Muestra las fechas extraídas

        return fechas;
      } else {
        print('Error al realizar la solicitud: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
