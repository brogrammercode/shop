import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String envFileName = '.env';

  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://192.168.1.2:4000/api/v1';
  }

  static String? get googleClientId {
    final value = dotenv.env['GOOGLE_CLIENT_ID']?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  static String? get googleServerClientId {
    final value = dotenv.env['GOOGLE_SERVER_CLIENT_ID']?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }
}
