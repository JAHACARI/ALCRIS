import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart'; // Ajusta esta ruta según la ubicación de tu archivo ApiConfig

class ApiService {
  Future<Map<String, dynamic>> restablecerContrasena({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  }) async {
    try {
      // Construye la URL tomando directamente ApiConfig.baseUrl
      final baseUrl = ApiConfig.baseUrl.endsWith('/')
          ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
          : ApiConfig.baseUrl;

      final url = Uri.parse('$baseUrl/auth/restablecer');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(), // req.body.email
          'codigo': codigo.trim(), // req.body.codigo
          'nueva_contrasena': nuevaContrasena, // req.body.nueva_contrasena
        }),
      ).timeout(const Duration(seconds: 45)); // Tiempo amplio por si Render está despertando

      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        responseData = jsonDecode(response.body);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'exito': true,
          'mensaje':
              responseData['message'] ?? 'Contraseña actualizada correctamente.',
        };
      } else {
        // Tu backend responde con { error: "..." } cuando falla (400, 404, etc.)
        return {
          'exito': false,
          'mensaje': responseData['error'] ??
              responseData['message'] ??
              'Error al actualizar la contraseña.',
        };
      }
    } on TimeoutException {
      return {
        'exito': false,
        'mensaje': 'El servidor tardó demasiado en responder. Intenta nuevamente.',
      };
    } on SocketException {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa tu internet.',
      };
    } on FormatException {
      return {
        'exito': false,
        'mensaje': 'El servidor devolvió una respuesta no válida.',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'Error inesperado al actualizar la contraseña.',
      };
    }
  }
}