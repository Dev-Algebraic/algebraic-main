import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  Future read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) != null) {
      return json.decode(prefs.getString(key)!);
    } else {
      return null;
    }
  }

  Future<int?>? readTime(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt(key) != null) {
      return prefs.getInt(key);
    } else {
      return null;
    }
  }

  Future<void> save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<void> saveServerOffsetTimeInSeconds(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
