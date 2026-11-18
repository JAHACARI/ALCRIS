import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/models/perfil.dart';

class PerfilService {
  final String baseUrl = 'https://onrender.com';

  Future<PerfilUsuario> obtenerPerfil({
    required String id,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final usuarioData = body['usuario'] ?? body;
      return PerfilUsuario.fromJson(usuarioData);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'Error al cargar el perfil');
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