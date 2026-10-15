import 'package:alcris/services/api_config.dart' as shared;

class ApiConfig {
  static String get baseUrl => shared.ApiConfig.baseUrl;

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
