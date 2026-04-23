import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';

class StorageService {
  static const String _historyKey = 'calc_history';
  static const String _settingsKey = 'calc_settings';

  // Lưu lịch sử
  static Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJson = history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_historyKey, historyJson);
  }

  // Tải lịch sử
  static Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? historyString = prefs.getStringList(_historyKey);
    if (historyString != null) {
      return historyString.map((item) => CalculationHistory.fromJson(jsonDecode(item))).toList();
    }
    return [];
  }
}