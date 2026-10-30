import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:http/http.dart' as http;
import 'admin_api.dart';
import 'api_config.dart'; // ✅ Importamos tu configuración global automatizada

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
  // ✅ ENLAZADO: Ahora consume dinámicamente tu URL configurada en ApiConfig
  static String get base => '${ApiConfig.baseUrl}/reservas';
  static Map<String, String> get _h => {'Authorization': 'Bearer ${AdminApi.token}'};

  static Future<List<ReservaPago>> misReservas() async {
    final res = await http.get(Uri.parse('$base/'), headers: _h);
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
    // ✅ Genera con total precisión la ruta limpia: https://onrender.com
    final urlFinal = '$base/$reservaId/comprobante';
    
    debugPrint('Petición directa de subida hacia: $urlFinal');
    
    final req = http.MultipartRequest('POST', Uri.parse(urlFinal))
      ..headers.addAll(_h)
      ..fields['monto'] = '$monto'
      ..fields['ref_nequi'] = ref 
      ..files.add(await http.MultipartFile.fromPath('comprobante', foto.path));
      
    // Le indicamos explícitamente al cliente de streams que mantenga la carga binaria
    req.followRedirects = true;
    req.maxRedirects = 5;

    final streamedRes = await req.send();
    final res = await http.Response.fromStream(streamedRes);
    
    // Imprime la respuesta exacta del backend en tu terminal
    debugPrint('SUBIR comprobante -> ${res.statusCode}: ${res.body}');

    Map<String, dynamic>? data;
    try {
      data = Map<String, dynamic>.from(jsonDecode(res.body));
    } catch (_) {}

    if (res.statusCode >= 400 || data?['ok'] != true) {
      throw PagoApiError(
          data?['error'] ?? 'El servidor no confirmó el envío (${res.statusCode})');
    }
  }
}
