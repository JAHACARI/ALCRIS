import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/models/perfil.dart'; // Importa tu modelo

class PerfilService {
  final String baseUrl = "https://alcris.onrender.com"; // Cambiar por tu URL backend

  Future<PerfilUsuario> obtenerPerfil(String token) async {
    final url = Uri.parse('$baseUrl/perfil');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Si tu API requiere autenticación
        },
      );

      if (response.statusCode == 200) {
        return PerfilUsuario.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al cargar el perfil: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
