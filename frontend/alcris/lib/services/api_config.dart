import 'dart:io';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class ApiConfig {
  /// Establece `API_BASE_URL` en tiempo de compilación para dispositivos físicos o servidores remotos.
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  // Si está en true, apunta a producción en Render. Si está en false, apunta a local.
  static const bool useRemote = true;

  static const String _remoteUrl = 'https://alcris.onrender.com';

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;
    if (useRemote) return '$_remoteUrl/api';
    if (!kIsWeb && Platform.isAndroid) {
      return 'https://127.0.0.1:3000'; // Dispositivos Android locales / Genymotion
    }
    return 'http://localhost:3000/api'; // iOS, Web y Escritorio
  }
}
