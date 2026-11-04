import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/services/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  List<dynamic> _extraerLista(dynamic datos, String clave) {
    if (datos is List) return datos;

    if (datos is Map<String, dynamic>) {
      if (datos[clave] is List) return datos[clave] as List<dynamic>;
      if (datos['data'] is List) return datos['data'] as List<dynamic>;
      final valorLista = datos.values.firstWhere(
        (value) => value is List,
        orElse: () => <dynamic>[],
      );
      return valorLista as List<dynamic>;
    }

    return <dynamic>[];
  }

  Future<List<dynamic>> obtenerServicios() async {
    final url = Uri.parse('$baseUrl/servicios');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode != 200) {
        throw Exception('Error del servidor: ${respuesta.statusCode}');
      }

      final cuerpo = utf8.decode(respuesta.bodyBytes);
      return _extraerLista(json.decode(cuerpo), 'servicios');
    } catch (e) {
      throw Exception('No se pudo conectar al backend: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerPaquetes(dynamic servicioId) async {
    // 🚀 Al registrar 'app.use("/api/paquetes", paqueteRoutes)' en Express, esta URL conectará de inmediato sin fallos
    final url = Uri.parse('$baseUrl/paquetes?servicio_id=$servicioId');
    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode != 200) {
        throw Exception('Error del servidor: ${respuesta.statusCode}');
      }

      final cuerpo = utf8.decode(respuesta.bodyBytes);
      final List<dynamic> listaRaw = json.decode(cuerpo) as List<dynamic>;
      return listaRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      throw Exception('No se pudo cargar los paquetes: $e');
    }
  }
}