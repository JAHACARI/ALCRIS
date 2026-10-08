import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';

  static Future<Map<String, dynamic>> enviarCodigoRecuperacion(String email) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/recuperar'); 
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'exito': true, 'mensaje': decodedResponse['message'] ?? 'Código enviado'};
      }
      return {'exito': false, 'mensaje': decodedResponse['message'] ?? 'El correo no existe'};
    } catch (e) {
      return {'exito': false, 'mensaje': 'Error de red: No se pudo conectar al servidor'};
    }
  }
}