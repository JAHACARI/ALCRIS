import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/services/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  Future<List<dynamic>> obtenerServicios() async {
    final url = Uri.parse('$baseUrl/servicios');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode != 200) {
        throw Exception('Error del servidor: ${respuesta.statusCode}');
      }

      final String cuerpo = utf8.decode(respuesta.bodyBytes);
      final dynamic datos = json.decode(cuerpo);

      // Backend puede devolver List directa o Map con clave 'servicios' / 'data'
      if (datos is List) {
        return datos;
      }

      if (datos is Map<String, dynamic>) {
        if (datos.containsKey('servicios') && datos['servicios'] is List) {
          return datos['servicios'] as List<dynamic>;
        }
        if (datos.containsKey('data') && datos['data'] is List) {
          return datos['data'] as List<dynamic>;
        }
        final valorLista = datos.values.firstWhere(
          (value) => value is List,
          orElse: () => <dynamic>[],
        );
        return valorLista as List<dynamic>;
      }

      return <dynamic>[];
    } catch (e) {
      throw Exception('No se pudo conectar al backend: $e');
    }
  }
}
