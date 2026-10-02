import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyHistory = 'omni_calc_history';
  static const String _keySavedFormulas = 'omni_calc_formulas';
  static const String _keyRegisters = 'omni_calc_registers';
  static const String _keyAngleUnit = 'omni_calc_angle_unit';

  static Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyHistory) ?? [];
  }

  static Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHistory, history);
  }

  static Future<List<String>> loadSavedFormulas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySavedFormulas) ?? [
      'sin(30) + cos(60)',
      'sqrt(3^2 + 4^2)',
      'log(100) * ln(e)',
      '2*pi*r',
    ];
  }

  static Future<void> saveSavedFormulas(List<String> formulas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySavedFormulas, formulas);
  }

  static Future<Map<String, double>> loadRegisters() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyRegisters);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(jsonStr);
        return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } catch (_) {}
    }
    return {'A': 0.0, 'B': 0.0, 'C': 0.0, 'D': 0.0, 'X': 0.0, 'Y': 0.0, 'Ans': 0.0};
  }

  static Future<void> saveRegisters(Map<String, double> registers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRegisters, json.encode(registers));
  }

  static Future<String> loadAngleUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAngleUnit) ?? 'deg';
  }

  static Future<void> saveAngleUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAngleUnit, unit);
  }
}
