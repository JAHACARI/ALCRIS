import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servicio.dart';

class AdminApiError implements Exception {
  final String message;
  AdminApiError(this.message);
  @override
  String toString() => message;
}

class AdminApi {
  static const base =  'http://10.0.2.2:3000/api/admin'; // emulador Android; // <- cambia por tu URL
  static String token = '';     
  static bool esAdmin = false;                   // <- JWT del admin tras el login

  static Future<dynamic> _send(String method, String path, [Map<String, dynamic>? body]) async {
    final req = http.Request(method, Uri.parse('$base$path'))
      ..headers.addAll({'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});
    if (body != null) req.body = jsonEncode(body);
    final res = await http.Response.fromStream(await req.send());
    final data = res.body.isEmpty ? null : jsonDecode(res.body);
    if (res.statusCode >= 400) throw AdminApiError(data?['error'] ?? 'Error ${res.statusCode}');
    return data;
  }

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
