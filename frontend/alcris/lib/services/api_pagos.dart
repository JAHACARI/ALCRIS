import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'admin_api.dart';

class ReservaPago {
  final int id, total;
  final String codigo, servicio, fecha, hora;
  final bool enRevision;
  ReservaPago.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        total = (j['total'] as num).toInt(),
        codigo = j['codigo'] ?? '',
        servicio = j['servicio'] ?? '',
        fecha = j['fecha'] ?? '',
        hora = j['hora'] ?? '',
        enRevision = j['enRevision'] == true;
}

class PagoApiError implements Exception {
  final String message;
  PagoApiError(this.message);
  @override
  String toString() => message;
}

class PagoApi {
  // ✅ Corregido: Apunta a tu API específica en Render y a la sección de pagos
  static const base = 'https://onrender.com';
  static Map<String, String> get _h => {'Authorization': 'Bearer ${AdminApi.token}'};

  static Future<List<ReservaPago>> misReservas() async {
    final res = await http.get(Uri.parse('$base/mis-reservas'), headers: _h);
    final data = jsonDecode(res.body);
    if (res.statusCode >= 400) throw PagoApiError(data['error'] ?? 'Error ${res.statusCode}');
    return [for (final j in data) ReservaPago.fromJson(j)];
  }

  static Future<void> subir({
    required int reservaId,
    required int monto,
    required String ref,
    required File foto,
  }) async {
    // ✅ Corregido: Se añade '/comprobante' para emparejar la ruta con el backend en Node.js
    final req = http.MultipartRequest('POST', Uri.parse('$base/$reservaId/comprobante'))
      ..headers.addAll(_h)
      ..fields['monto'] = '$monto'
      ..fields['ref_nequi'] = ref
      ..files.add(await http.MultipartFile.fromPath('comprobante', foto.path));
    final res = await http.Response.fromStream(await req.send());
    if (res.statusCode >= 400) {
      String msg = 'Error ${res.statusCode}';
      try {
        msg = jsonDecode(res.body)['error'] ?? msg;
      } catch (_) {}
      throw PagoApiError(msg);
    }
  }
}