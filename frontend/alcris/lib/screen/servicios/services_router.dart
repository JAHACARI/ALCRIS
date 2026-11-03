import 'package:flutter/material.dart';
import 'package:alcris/screen/servicios/detallediagnostico.dart';
import 'package:alcris/screen/servicios/detallelavado.dart';
import 'package:alcris/screen/servicios/detallepaquete.dart';
import 'package:alcris/screen/servicios/colores_screen.dart';
 
typedef ServicioBuilder = Widget Function(Map<String, dynamic> servicio);
 
class ServicioRouter {
  /// Para agregar un tipo de pantalla nuevo, solo añade una línea aquí.
  static final Map<String, ServicioBuilder> _pantallas = {
    'diagnostico': (s) => DetalleServiciodi(servicio: s),
    'lavado': (s) => DetalleServiciolav(servicio: s),
    'pintura': (s) => ColoresScreen(servicio: s),
    'paquetes': (s) => DetalleServicioScreen(servicio: s),
  };
 
  static String _normalizar(String t) {
    const de = 'áéíóúüñ', a = 'aeiouun';
    var r = t.toLowerCase().trim();
    for (var i = 0; i < de.length; i++) {
      r = r.replaceAll(de[i], a[i]);
    }
    return r;
  }
 
  /// Usa el campo `tipo` del backend. Si no viene (servicios antiguos),
  /// lo infiere del nombre. Un tipo desconocido cae en 'paquetes'.
  static String tipoDe(Map<String, dynamic> backend) {
    final tipo = _normalizar((backend['tipo'] ?? '').toString());
    if (_pantallas.containsKey(tipo)) return tipo;
 
    final nombre = _normalizar((backend['nombre'] ?? '').toString());
    if (nombre.contains('diagnostico') || nombre.contains('revision')) {
      return 'diagnostico';
    }
    if (nombre.contains('lavado') || nombre.contains('limpieza')) {
      return 'lavado';
    }
    if (nombre.contains('pintura')) return 'pintura';
    return 'paquetes';
  }
 
  static Widget pantallaPara(Map<String, dynamic> servicio) {
    final builder = _pantallas[servicio['tipo']] ?? _pantallas['paquetes']!;
    return builder(servicio);
  }
 
  static Future<T?> abrir<T>(
    BuildContext context,
    Map<String, dynamic> servicio,
  ) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => pantallaPara(servicio)),
    );
  }
}
 