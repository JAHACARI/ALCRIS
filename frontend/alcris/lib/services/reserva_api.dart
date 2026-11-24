import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alcris/models/reserva_usuario.dart';
import 'package:alcris/services/admin_api.dart';
import 'package:alcris/services/api_config.dart';

class ReservaApi {
  static Future<List<ReservaUsuario>> misReservas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? AdminApi.token;

    if (token.isEmpty) {
      throw Exception('No se encontró la sesión del usuario');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/reservas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final lista = body['reservas'] ?? body;
      if (lista is List) {
        return lista
            .whereType<Map>()
            .map((item) => ReservaUsuario.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return <ReservaUsuario>[];
    }

    if (response.statusCode == 401) {
      throw Exception('Tu sesión expiró. Inicia sesión nuevamente.');
    }

    throw Exception('No pudimos cargar tus reservas. Intenta de nuevo.');
  }
}
