import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;
  init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<String> getPref(String key) async {
    final SharedPreferences? prefs = _sharedPrefs;
    return prefs?.getString(key) ?? '';
  }

  setPref(String key, String value) async {
    final SharedPreferences? prefs = _sharedPrefs;
    prefs?.setString(key, value) ?? '';
  }

  setStringList(String key, List<String> value) async {
    final SharedPreferences? prefs = _sharedPrefs;
    prefs?.setStringList(key, value) ?? '';
  }

  Future<List<String>> getStringList(String key) async {
    final SharedPreferences? prefs = _sharedPrefs;
    return prefs?.getStringList(key) ?? [];
  }

  removePref(String key) async {
    final SharedPreferences? prefs = _sharedPrefs;
    prefs?.remove(key);
  }
}

final sharedPrefs = SharedPrefs();
