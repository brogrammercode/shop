import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _notificationPollingSecondsKey =
      'notification_polling_seconds';
  static const String _kdsPollingSecondsKey = 'kds_polling_seconds';
  static const int _defaultNotificationPollingSeconds = 10;
  static const int _defaultKdsPollingSeconds = 10;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> clearSession() async {
    await clearToken();
  }

  Future<void> saveNotificationPollingSeconds(int seconds) async {
    await _storage.write(
      key: _notificationPollingSecondsKey,
      value: seconds.toString(),
    );
  }

  Future<int> getNotificationPollingSeconds() async {
    final value = await _storage.read(key: _notificationPollingSecondsKey);
    return int.tryParse(value ?? '') ?? _defaultNotificationPollingSeconds;
  }

  Future<void> saveKdsPollingSeconds(int seconds) async {
    await _storage.write(key: _kdsPollingSecondsKey, value: seconds.toString());
  }

  Future<int> getKdsPollingSeconds() async {
    final value = await _storage.read(key: _kdsPollingSecondsKey);
    return int.tryParse(value ?? '') ?? _defaultKdsPollingSeconds;
  }
}
