import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP correcta para el emulador de Android apuntando al puerto 3000 de tu Express
  static const String baseUrl = "http://10.0.2.2:3000/api";

  // ---------- CATÁLOGO DE SERVICIOS ----------
  Future<List<dynamic>> obtenerServicios() async {
    final url = Uri.parse('$baseUrl/servicios');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final String cuerpoDecodificado = utf8.decode(respuesta.bodyBytes);
        final Map<String, dynamic> datosJson = json.decode(cuerpoDecodificado);
        
        if (datosJson.containsKey('servicios')) {
          return datosJson['servicios'] as List<dynamic>;
        } 
        if (datosJson.containsKey('data')) {
          return datosJson['data'] as List<dynamic>;
        }

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

  // ---------- REGISTRO DE USUARIOS ----------
  Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String email,
    required String contrasena,
    required String telefono,
    required String localidad, 
  }) async {
    final url = Uri.parse('$baseUrl/auth/registro');

    try {
      final respuesta = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'nombre': nombre,
          'email': email,
          'contrasena': contrasena,
          'telefono': telefono,   
          'localidad': localidad, 
        }),
      );

      final Map<String, dynamic> datosJson = json.decode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
        return datosJson; 
      } else {
        throw Exception(datosJson['error'] ?? 'Error al registrar el usuario');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor: $e');
    }
  }

  // ---------- INICIO DE SESIÓN (LOGIN) ----------
  Future<Map<String, dynamic>> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login'); 

    try {
      final respuesta = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email,
          'contrasena': contrasena,
        }),
      );

      final Map<String, dynamic> datosJson = json.decode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode == 200) {
        return datosJson; 
      } else {
        throw Exception(datosJson['error'] ?? 'Error ${respuesta.statusCode}: No se pudo iniciar sesión');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor: $e');
    }
  }

  // ---------- VERIFICAR CUENTA ----------
  Future<Map<String, dynamic>> verificarCuenta({
    required String email,
    required String codigo,
  }) async {
    final url = Uri.parse('$baseUrl/auth/verificar'); 

    try {
      final respuesta = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'email': email, 'codigo': codigo}),
      );

      final Map<String, dynamic> datosJson = json.decode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode == 200) {
        return datosJson;
      } else {
        throw Exception(datosJson['error'] ?? 'Código incorrecto o expirado.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ---------- REENVIAR CÓDIGO DE VERIFICACIÓN ----------
  Future<Map<String, dynamic>> reenviarCodigoVerificacion({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reenviar-codigo'); 

    try {
      final respuesta = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'email': email}),
      );

      final Map<String, dynamic> datosJson = json.decode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode == 200) {
        return datosJson;
      } else {
        throw Exception(datosJson['error'] ?? 'No se pudo reenviar el código.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
