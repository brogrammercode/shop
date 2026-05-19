import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/business/models/business_context_model.dart';

class LocalStorage {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _businessContextKey = 'business_context';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final value = await _storage.read(key: _userKey);
    if (value == null) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  Future<void> saveBusinessContext(BusinessContextModel context) async {
    await _storage.write(
      key: _businessContextKey,
      value: jsonEncode(context.toJson()),
    );
  }

  Future<BusinessContextModel?> getBusinessContext() async {
    final value = await _storage.read(key: _businessContextKey);
    if (value == null) {
      return null;
    }

    return BusinessContextModel.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
  }

  Future<void> clearBusinessContext() async {
    await _storage.delete(key: _businessContextKey);
  }

  Future<void> clearSession() async {
    await clearToken();
    await clearUser();
    await clearBusinessContext();
  }
}
