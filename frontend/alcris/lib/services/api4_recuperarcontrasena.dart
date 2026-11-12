import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart'; // Importamos tu archivo de configuración

class ApiService {
  // Ahora la URL se obtiene dinámicamente según la configuración de tu ApiConfig
  static String get _baseUrl => ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> enviarCodigoRecuperacion(String email) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/recuperar');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      );

      final decodedResponse = jsonDecode(response.body);

      // Si todo sale bien (status 200 o 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'exito': true,
          // Si tu backend exitoso devuelve 'message', lo lee aquí
          'mensaje': decodedResponse['message'] ?? 'Código enviado con éxito.'
        };
      }

      // SOLUCIÓN: Si falla, tu backend de Node.js envía la propiedad 'error'
      return {
        'exito': false,
        'mensaje': decodedResponse['error'] ?? decodedResponse['message'] ?? 'Ocurrió un error en el servidor.'
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'Error de red: No se pudo conectar al servidor'
      };
    }
  }
}