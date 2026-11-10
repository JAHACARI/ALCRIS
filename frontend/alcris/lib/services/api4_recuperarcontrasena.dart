import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart'; // Asegúrate de ajustar esta ruta según la carpeta de tu proyecto

class ApiService {
  static Future<Map<String, dynamic>> enviarCodigoRecuperacion(String email) async {
    try {
      // Construye la URL tomando directamente ApiConfig.baseUrl
      final baseUrl = ApiConfig.baseUrl.endsWith('/') 
          ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1) 
          : ApiConfig.baseUrl;
          
      final url = Uri.parse('$baseUrl/auth/recuperar');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      ).timeout(const Duration(seconds: 45)); // Tiempo amplio por si Render está despertando

      Map<String, dynamic> decodedResponse = {};
      if (response.body.isNotEmpty) {
        decodedResponse = jsonDecode(response.body);
      }

      // Si todo sale bien (status 200 o 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'exito': true,
          'mensaje': decodedResponse['message'] ?? 'Código enviado con éxito.'
        };
      }

      // Si falla, lee la propiedad 'error' o 'message' de tu backend
      return {
        'exito': false,
        'mensaje': decodedResponse['error'] ?? decodedResponse['message'] ?? 'Ocurrió un error en el servidor.'
      };
      
    } on TimeoutException {
      return {
        'exito': false,
        'mensaje': 'El servidor tardó demasiado en responder. Intenta nuevamente.'
      };
    } on SocketException {
      return {
        'exito': false,
        'mensaje': 'Error de red: No se pudo conectar al servidor.'
      };
    } on FormatException {
      return {
        'exito': false,
        'mensaje': 'El servidor devolvió una respuesta no válida.'
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'Error inesperado al conectar con el servidor.'
      };
    }
  }
}
