import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/models/perfil.dart';

class PerfilService {
  // URL real de tu backend en Render
  final String baseUrl = 'https://onrender.com';

  Future<PerfilUsuario> obtenerPerfil(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/perfil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return PerfilUsuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el perfil');
    }
  }

  Future<void> eliminarCuenta({
    required String id,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/$id');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'No se pudo eliminar la cuenta');
    }
  }
}