import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonCache {
  static const String _userDataFile = 'user_data.json';

  Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<void> saveUser(Map<String, dynamic> data) async {
    final file = await _getFile(_userDataFile);
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      final file = await _getFile(_userDataFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<void> clearUser() async {
    try {
      final file = await _getFile(_userDataFile);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  Future<void> clearAll() async {
    await clearUser();
  }

  static const String _savedProfileFile = 'saved_profile.json';

  Future<void> saveSavedProfile(Map<String, dynamic> data) async {
    final file = await _getFile(_savedProfileFile);
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getSavedProfile() async {
    try {
      final file = await _getFile(_savedProfileFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<void> clearSavedProfile() async {
    try {
      final file = await _getFile(_savedProfileFile);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
