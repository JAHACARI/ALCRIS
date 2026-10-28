import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://127.0.0.1:3000/api';

  Future<Map<String, dynamic>> restablecerContrasena({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  }) async {
    // Apunta a la ruta asociada a tu función restablecerPassword
    final url = Uri.parse('$_baseUrl/auth/restablecer');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email, // req.body.email
          'codigo': codigo, // req.body.codigo
          'nueva_contrasena': nuevaContrasena, // req.body.nueva_contrasena
        }),
      );

      // Decodificamos la respuesta del servidor
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'exito': true,
          'mensaje':
              responseData['message'] ??
              'Contraseña actualizada correctamente.',
        };
      } else {
        // Tu backend responde con { error: "..." } cuando falla (400, 404, etc.)
        return {
          'exito': false,
          'mensaje':
              responseData['error'] ?? 'Error al actualizar la contraseña.',
        };
      }
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa tu internet.',
      };
    }
  }
}
