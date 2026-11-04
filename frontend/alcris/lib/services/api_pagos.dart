import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alcris/services/api_config.dart';
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
  static Map<String, String> get _h => {'Authorization': 'Bearer ${AdminApi.token}'};

  // GET /api/pagos/mis-reservas
  static Future<List<ReservaPago>> misReservas() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/pagos/mis-reservas'),
      headers: _h,
    );
    dynamic data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      throw PagoApiError('Respuesta inesperada del servidor (${res.statusCode})');
    }
    if (res.statusCode >= 400) {
      throw PagoApiError(data['error'] ?? 'Error ${res.statusCode}');
    }
    return [for (final j in data) ReservaPago.fromJson(j)];
  }

  // POST /api/reservas/:id/comprobante
  static Future<void> subir({
    required int reservaId,
    required int monto,
    required String ref,
    required File foto,
  }) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/reservas/$reservaId/comprobante'),
    )
      ..headers.addAll(_h)
      ..fields['monto'] = '$monto'
      ..fields['ref_nequi'] = ref
      ..files.add(await http.MultipartFile.fromPath('comprobante', foto.path));

    final res = await http.Response.fromStream(await req.send());
    debugPrint('SUBIR comprobante -> ${res.statusCode}: ${res.body}');

    Map<String, dynamic>? data;
    try {
      data = Map<String, dynamic>.from(jsonDecode(res.body));
    } catch (_) {}

    // Solo es éxito si el servidor confirma con ok: true
    if (res.statusCode >= 400 || data?['ok'] != true) {
      throw PagoApiError(
          data?['error'] ?? 'El servidor no confirmó el envío (${res.statusCode})');
    }
  }
}