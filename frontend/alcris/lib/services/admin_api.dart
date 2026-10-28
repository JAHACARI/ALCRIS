import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servicio.dart';
import 'api_config.dart'; // 👈 Se importa tu archivo de configuración centralizado

class AdminApiError implements Exception {
  final String message;
  AdminApiError(this.message);
  @override
  String toString() => message;
}

class AdminApi {
  // 💡 Toma dinámicamente la URL base global (Render) y le concatena '/admin' SOLO para este archivo
  static final String base = '${ApiConfig.baseUrl}/admin'; 
  static String token = '';     
  static bool esAdmin = false;                   

  static Future<dynamic> _send(String method, String path, [Map<String, dynamic>? body]) async {
    final req = http.Request(method, Uri.parse('$base$path'))
      ..headers.addAll({'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});
    if (body != null) req.body = jsonEncode(body);
    final res = await http.Response.fromStream(await req.send());
    final data = res.body.isEmpty ? null : jsonDecode(res.body);
    if (res.statusCode >= 400) throw AdminApiError(data?['error'] ?? 'Error ${res.statusCode}');
    return data;
  }
  
  // Resumen y reservas
  static Future<Map<String, dynamic>> resumen() async =>
      Map<String, dynamic>.from(await _send('GET', '/resumen'));
  static Future<List<ReservaAdmin>> reservas() async =>
      [for (final j in await _send('GET', '/reservas')) ReservaAdmin.fromJson(j)];
  static Future<List<String>> estados() async =>
      List<String>.from(await _send('GET', '/estados'));
  static Future<void> cambiarEstado(int id, String estado) =>
      _send('PATCH', '/reservas/$id', {'estado': estado});
      
  // Servicios
  static Future<List<ServicioAdmin>> servicios() async =>
      [for (final j in await _send('GET', '/servicios')) ServicioAdmin.fromJson(j)];
  static Future<void> crearServicio(String n, String d, int p) =>
      _send('POST', '/servicios', {'nombre': n, 'descripcion': d, 'precio': p});
  static Future<void> editarServicio(int id, String n, String d, int p) =>
      _send('PUT', '/servicios/$id', {'nombre': n, 'descripcion': d, 'precio': p});
  static Future<void> eliminarServicio(int id) => _send('DELETE', '/servicios/$id');

  // Pagos
  static Future<List<PagoAdmin>> pagos() async =>
      [for (final j in await _send('GET', '/pagos?estado=revision')) PagoAdmin.fromJson(j)];
  static Future<void> aceptarPago(int id) => _send('POST', '/pagos/$id/aceptar');
  static Future<void> rechazarPago(int id, String motivo) =>
      _send('POST', '/pagos/$id/rechazar', {'motivo': motivo});
}
