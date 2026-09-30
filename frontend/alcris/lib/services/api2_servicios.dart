import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP correcta para el emulador de Android apuntando al puerto 3000 de tu Express
  static const String baseUrl = "http://10.0.2.2:3000/api";
  // Esta es la función que debes revisar
  Future<List<dynamic>> obtenerServicios() async {
    final url = Uri.parse('$baseUrl/servicios');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final String cuerpoDecodificado = utf8.decode(respuesta.bodyBytes);

        // 1. Primero decodificamos el JSON completo como un Mapa/Objeto
        final Map<String, dynamic> datosJson = json.decode(cuerpoDecodificado);

        // 2. Extraemos la lista que está guardada dentro.
        // Si en tu backend pusiste res.json(servicios), la clave suele ser 'servicios'
        if (datosJson.containsKey('servicios')) {
          return datosJson['servicios'] as List<dynamic>;
        }

        // Si en tu backend pusiste res.json({ data: servicios }), la clave es 'data'
        if (datosJson.containsKey('data')) {
          return datosJson['data'] as List<dynamic>;
        }

        // Si tu backend tiene otra estructura o una propiedad diferente,
        // tomamos el primer valor que sea una lista para evitar que la app se rompa
        final valorLista = datosJson.values.firstWhere(
          (value) => value is List,
          orElse: () => [],
        );

        return valorLista as List<dynamic>;
      } else {
        throw Exception("Error del servidor: ${respuesta.statusCode}");
      }
    } catch (e) {
      throw Exception("No se pudo conectar al backend: $e");
    }
  }
}
